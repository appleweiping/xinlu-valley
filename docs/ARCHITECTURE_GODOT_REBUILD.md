# AI Town Godot Rebuild Architecture

## Active Direction

AI Town is a local-first Godot game that turns the user's real computer workspace into a playable town. Godot owns the playable experience. FastAPI owns local adapters, permission gates, task execution, and model/agent integration.

The previous Phaser/React architecture is now legacy reference material.

## Core Principles

- Real data only: unavailable systems are shown as unavailable, not mocked.
- Local-first: D-drive project files, shared memory, research roots, devtools, and agent infrastructure are primary sources.
- Non-destructive by default: reads are smooth; writes require explicit scope and safety class.
- Dynamic registry over hard-coding: buildings, rooms, agents, tools, workspaces, and quests should migrate to config files.
- Game first, dashboard second: every real workflow should map to places, characters, quests, rewards, and progression.

## Runtime Layers

```text
Godot Client
  - town map, movement, camera
  - building entry and room scenes
  - HUD, quest board, badge case
  - room consoles for real workflows
  - API client and local save

FastAPI Local Bridge
  - building registry and room payloads
  - workspace registry and allowlisted filesystem roots
  - quest registry and progression payloads
  - cached allowlisted knowledge index and search
  - filesystem/research/memory/devtools adapters
  - agent roster, dispatch drafts, safe local task queue, and tool registry
  - model gateway and dialogue
  - async job queue for slow inspections and bounded agent/tool work
  - permission gates and execution logs
  - plugin registry

Local Real Systems
  - D:\Research
  - D:\research\Vipin's Knowledgebase\memory
  - D:\agent-resources
  - D:\devtools
  - Git repositories
  - optional agent runners and API gateways
```

## Building Contract

Each building should eventually be declared by registry data:

- `id`
- display name
- map position and room scene
- NPC/agent assignment
- backend adapter
- safety class
- supported actions
- quest hooks
- real local paths or services

`godot/data/room_scenes.json` and `godot/data/npc_quests.json` currently provide data-driven interiors and NPC chains for all thirty-five core workflow buildings in the current registry: File Vault, Research Hall, Code Workshop, Agent Hub, Testing Arena, Memory Library, Knowledge Tower, GitHub Harbor, Terminal Control, Model Market, Paper Reading Room, Download Station, Backup Station, Inspiration Collection Station, Local Office Center, Schedule and Plan Center, Learning Training Grounds, Language Learning Area, Research Data Center, Version Release Plaza, System Monitor, Permission Hall, Settings Center, Task Board, Writing Studio, Automation Factory, Bug Clinic, Project Management Hall, Asset Resource Gallery, Skill Workshop, Devtools Lab, Town Hall, Plugin Registry, Long-Term Goal Tower, and Temporary Draft Box. Room stations call existing safe Godot actions; they do not grant new filesystem, shell, Git, agent, or API permissions.

The room-stage renderer is still procedural, but it now uses the registry data to produce warmer storybook interiors: layered parchment flooring, room accent panels, stone path tiles, wooden/NPC anchors, ambient ribbons, keyword-colored prop blocks, and distinct hover/pressed hotspot styles. This keeps the client lightweight and data-driven while moving the visual layer toward the long-term hand-painted/pixel-hybrid baseline.

`tools/verify-smoke.ps1` now enforces the room/NPC/action contract as a release gate. It loads the room-scene registry, NPC-chain registry, and Godot `Main.gd` directly, then verifies one-to-one room/chain coverage, unique station and stage IDs, station geometry inside the 580x210 room stage, non-empty station/stage actions, and a matching `_run_room_scene_action` branch for every action referenced by registry data.

`tools/capture-room-visuals.ps1` now uses the same room-scene registry for visual evidence. Its default mode captures every room scene, writes per-room screenshots under `screenshots/`, and records `screenshots/room-scenes-manifest.json` with room IDs, titles, byte sizes, and SHA-256 hashes. The `-Quick` mode keeps the smaller five-room developer smoke set.

`GET /api/testing-arena/visual-manifest` audits that manifest without starting Godot or changing assets. It compares manifest room IDs to `godot/data/room_scenes.json`, rejects screenshot paths outside `screenshots/`, checks file existence and minimum byte size, recomputes SHA-256 hashes, and reports coverage in Testing Arena, Version Release Plaza, vertical-slice proofs, release-readiness reports, and smoke tests.

`GET /api/version-release-plaza/build-readiness` audits Godot build/export readiness without starting exports or services. It checks `godot/project.godot`, Godot 4.6 targeting, `res://scenes/main.tscn`, `godot/scripts/Main.gd`, pinned Godot GUI/console binaries under `tools/godot`, project launchers, `godot/export_presets.cfg`, the Windows Desktop export path, embedded PCK setting, and the project-local `dist/ai-town` target. This gives Release Plaza a concrete executable-readiness gate while keeping packaging and publication as later explicit workflows.

`tools/install-godot-templates.ps1` installs Godot 4.6.3 Windows export templates under the project on D:, and `tools/export-godot.ps1` is the safe local export path. By default it performs a preflight and writes `workspace/export-reports/latest-godot-export-report.json`; `-RunExport` is required before invoking Godot export, and `-Overwrite` is required before replacing an existing executable. `GET /api/version-release-plaza/export-tool` reads that report for Version Release Plaza, including command preview, output path, template path, blocker count, and latest status. The current local export produced `dist/ai-town/AI Town.exe` with zero blockers and a successful exported-game headless check.

`start-packaged.cmd` is the normal local-play path for the exported build. It verifies `dist/ai-town/AI Town.exe`, probes `http://127.0.0.1:8000/api/health`, starts only this project's backend window when the health check is absent, waits for readiness, and then opens the packaged Godot executable. `GET /api/version-release-plaza/packaged-launch` audits the launcher without running it and verifies that it does not contain `taskkill`.

`tools/write-release-manifest.ps1` writes `workspace/release-package/release-manifest.json` for the current local package. It records file sizes and SHA-256 hashes for `dist/ai-town/AI Town.exe`, the dist README, packaged launcher, latest export report, and smoke verifier. `GET /api/version-release-plaza/release-manifest` recomputes those hashes before Release Plaza treats the package as evidence. The manifest path is evidence only; packaging, zipping, signing, Git tagging, and publishing remain separate future workflows.

Current registry-backed buildings:

- Memory Library: shared memory shelves and note previews.
- Research Hall: real research project boards and experiment candidates.
- Agent Hub: detected local agent launchers, mailbox/log status, dispatch drafts, safe local task queue, and safe tool registry.
- Code Workshop: local Git project index, repo detail, README/TODO preview, recent commits.
- GitHub Harbor: local Git remotes, branches, tags, read-only GitHub CLI status, publish-readiness checks, local PR/issue/release drafts, and confirm-gated publish plans.
- Terminal Control: allowlisted local command jobs, confirmation gates, async execution, and project-local logs.
- System Monitor: service health, backend jobs, registries, workspace logs, and warning surfaces.
- Model Market: model/API gateway profiles, environment readiness, and no-secret key status.
- File Vault: allowlisted D-drive roots, lazy directory browsing, bounded text previews, cached search, and project-local tags.
- Task Board: local task ledger, dispatch drafts, memory events, and project-local task creation.
- Writing Studio: project document index and safe project-local Markdown draft creation.
- Automation Factory: local script catalog, verification workflow visibility, and draft-only automation blueprints.
- Permission Hall: read-only safety classes, confirmation gates, write scopes, file allowlists, and audit signals.
- Settings Center: active registries, launchers, model environment requirements, and settings drafts.
- Testing Arena: smoke scripts, visual proof artifacts, terminal logs, verification history, and test-plan drafts.
- Bug Clinic: failed jobs/logs, known diagnostics, memory-event signals, and bug-report drafts.
- Project Management Hall: local project portfolio, research boards, task status, Git dock counts, and project brief drafts.
- Download Station: allowlisted download/import roots, recent file classification, and intake drafts.
- Asset Resource Gallery: runtime asset folders, source art, visual baseline docs, screenshots, and curation notes.
- Local Office Center: company workspace samples, project docs, office follow-up notes, and safe routing prompts.
- Schedule and Plan Center: PLAN tasks, local task status, office notes, memory signals, and schedule drafts.
- Learning Training Grounds: local skill index, practice tracks, workflow signals, and learning plans.
- Language Learning Area: multilingual UI signals, phrase cards, bilingual practice notes, and review loops.
- Research Data Center: bounded research dataset/result maps, provenance prompts, and local audit notes.
- Paper Reading Room: bounded paper/reference discovery, citation-audit prompts, and local reading notes.
- Version Release Plaza: release-readiness artifacts, screenshot evidence, Godot build/export readiness, safe export-tool reports, packaged-launch readiness, release package hashes, Git status, and checklist drafts.
- Plugin Registry: bounded extension candidate inventory, runtime registry status, and plugin proposal drafts.
- Backup Station: backup source candidates, target folder snapshots, restore-check prompts, and plan drafts.
- Long-Term Goal Tower: PLAN checklist status, shared-memory signals, portfolio counts, and goal drafts.
- Inspiration Collection Station: project idea signals, visual baseline references, nearby drafts, and inspiration notes.
- Temporary Draft Box: project-local draft shelf inventory, scratch notes, and route hints.
- Skill Workshop: local skill index.
- Knowledge Tower: allowlisted cached knowledge index, async refresh jobs, search, and bounded previews.
- Devtools Lab: local command launcher inventory.
- Town Hall: shared architecture decisions.
- Resource Market: agent resource directory.

The first registry files live at:

- `godot/data/buildings.json`
- `godot/data/agents.json`
- `godot/data/model_profiles.json`
- `godot/data/workspaces.json`
- `godot/data/quests.json`

Godot loads these registries on startup and falls back to internal defaults if they are missing or malformed. The backend exposes the same registry data via:

- `GET /api/config/buildings`
- `GET /api/config/agents`
- `GET /api/config/workspaces`
- `GET /api/config/quests`

## Safety Classes

- `read-only`: list, preview, inspect, summarize.
- `preview-only`: generate draft text or a plan without changing external systems.
- `project-local-write`: write only under `D:\Game_develop\ai-town\workspace`.
- `project-local-memory-event`: record gameplay/work events under the AI Town workspace without editing the external source project.
- `confirm-required`: requires explicit confirmation phrase or UI confirmation.
- `external-write`: future category for git commits, file edits outside the project, installs, and command execution.
- `dangerous`: delete, overwrite, long-running experiments, service shutdown, credential changes. These need strong confirmation and should usually be avoided from gameplay shortcuts.

## Async Work Rule

Godot must stay responsive. Slow operations such as Git analysis, code indexing, PDF parsing, embeddings, model calls, terminal tasks, and agent execution should run through backend jobs or task queues.

The first implemented job path is Code Workshop repo inspection:

1. Godot requests `POST /api/projects/{project_id}/inspect-job`.
2. Backend queues a read-only `project-inspect` job with concurrency limit 2.
3. Backend uses the project index cache to avoid rescanning roots for selected repo detail.
4. Godot polls `GET /api/jobs/{job_id}`.
5. Result is rendered when complete.

This pattern should replace direct blocking calls for all future heavy work.

Terminal Control now reuses this job path for allowlisted command execution. Commands are not free-form shell strings; they are fixed command specs with bounded timeouts, project-local working directories, `RUN_LOCAL_COMMAND` confirmation, and logs written under `workspace/terminal-logs`. `GET /api/terminal/commands/{command_id}/preview` exposes a read-only dry-run card with argv, cwd allowlist status, timeout, confirmation phrase, expected effects, and blocked reasons before any command can be queued.

System Monitor provides the first read-only observability surface for this runtime: service status, job counts, recent jobs, registry counts, workspace folder state, and terminal logs.

Model Market adds a no-secret gateway status surface. Model profiles live in `godot/data/model_profiles.json`; backend responses expose env var names, configured/missing flags, model lists, and base URLs, but never raw API keys.

Workspace Registry now makes local roots data-driven. `godot/data/workspaces.json` declares allowlisted workspace roots, each with separate flags for File Vault browsing and project discovery. The backend exposes this through `/api/config/workspaces`, uses it for File Vault roots, uses project-enabled roots for Code Workshop discovery, and reports the registry in Settings Center, System Monitor, and Plugin Registry. If the file is missing or malformed, built-in fallback roots keep the game usable.

Quest Registry now makes the first work progression loop data-driven. `godot/data/quests.json` defines chapters, target buildings, ordered steps, badge rewards, collections, next hints, and safety classes. The backend resolves lightweight live summary templates for memory, skill, and workspace counts, then exposes the active quests through `/api/config/quests` and `/api/workbench/quests`. Godot loads the same registry as a local fallback while preserving local accepted/completed quest and badge save data.

File Vault now uses the workspace registry and lazy path API rather than recursive scans. Godot can list roots, open one directory page, and preview small text-like files while the backend rejects traversal and large/binary previews. It also has an incremental async cached search layer: `POST /api/file-vault/index-job` refreshes `workspace/file-vault-index/file-vault-index.json` with per-root depth and item limits, compares refreshed entries by stable id, `mtime`, and size, reports new/changed/reused/removed/preserved counts through `GET /api/file-vault/index`, preserves untouched cached roots during partial refreshes, `GET /api/file-vault/search` reads paginated cached results, `GET /api/file-vault/organize-audit` summarizes cached organization groups/duplicates/stale tags without scanning live folders, and `POST /api/file-vault/tags` writes project-local labels to `workspace/file-vault-index/file-tags.json` without touching source files.

Knowledge Tower now uses a project-local cached index instead of live recursive scans. `POST /api/knowledge/index-job` refreshes allowlisted roots through the backend job queue, writing `workspace/knowledge-index/knowledge-index.json`; `GET /api/knowledge/index`, `/api/knowledge/search`, and `/api/knowledge/items/{doc_id}` read cache state, paginated results, and bounded previews. Current roots cover the shared knowledge base, shared memory, AI Town docs/root docs, and agent resources, with depth, extension, per-root, and ignore-directory limits.

Task Board consolidates project-local tasks, dispatch drafts, and memory events into a single game-facing board. New tasks are project-local draft files and ledger entries only; real agent dispatch remains a future confirm-required workflow.

Agent Task Queue gives Agent Hub its first bounded execution substrate. It supports `memory-brief`, `project-brief`, and `workspace-brief` tasks, plus pause/resume/cancel for queued work, in-memory status, timeline events, rollback notes, and JSON logs under `workspace/agent-task-logs`. `GET /api/agent-tasks/policy` exposes the safe local queue concurrency policy: `AI_TOWN_AGENT_TASK_MAX_RUNNING` defaults to 1, active tasks move through `queued -> dispatching -> running -> done/failed/cancelled`, queue snapshots expose saturated/backpressure state, and each dispatched task records a concurrency-policy event before the read-only brief builder starts. `GET /api/agent-tasks/logs` and `/api/agent-tasks/logs/{log_id}` expose a durable, read-only task log archive with bounded result previews, so completion/failure/cancel evidence survives in-memory queue churn and can be inspected from Agent Hub without replaying work. It does not invoke external agent runners, stop services, run arbitrary commands, mutate source projects, or contact remote APIs; it is a safe bridge between game-visible coordination and local read-only summaries.

Agent Runner Readiness is the preflight layer for real external agents. It inspects known `D:\devtools` launcher candidates, reports launcher readiness/blockers, hashes and secret-redacts launcher file previews, and writes confirm-required dispatch handoff packages under `workspace/agent-runner-dispatches`. `POST /api/agent-runners/launch-jobs` then exposes a launch gate with exact argv preview and requires `RUN_AGENT_RUNNER`; dry-run and missing-confirmation calls do not start any process. Confirmed launch jobs redact stdout/stderr before returning or logging them and must not stop, kill, or interfere with unrelated processes.

All user-facing preview surfaces must avoid raw secret display. The shared `redact_secret_text` helper is applied to Knowledge Tower previews, File Vault previews, Code Workshop file previews, Agent Runner launcher previews, and runner stdout/stderr logs. Cache writers should store redacted preview text, not just redact at render time, so project-local evidence files remain safe to inspect.

Agent Tool Registry is the first explicit tool-calling layer for future real agents. It registers safe adapters such as `memory-index`, `knowledge-search`, `file-search`, `project-index`, and `system-snapshot`; invocations run through the backend job executor, write JSON logs under `workspace/agent-tool-logs`, and record local memory events. `GET /api/agent-tools/logs` and `/api/agent-tools/logs/{log_id}` expose those durable records as a bounded, read-only archive with redacted result previews, so Agent Hub can inspect completed tool evidence after the in-memory invocation queue changes without replaying tools. This creates the shape needed for real coding/research agents without opening arbitrary shell execution or external agent runners.

Writing Studio establishes the first office/document workflow. It indexes core project Markdown docs and creates new drafts only under `workspace/drafts`, with a memory event trail for later review.

Automation Factory establishes the first automation planning workflow. It catalogs known project scripts and launchers, marks shutdown helpers as blocked/manual-only, and creates draft blueprints only under `workspace/automation-drafts`. It does not run scripts or install schedulers; future activation should use a confirm-required backend runner with logs, rollback notes, and pause/resume state.

Permission Hall makes the safety model visible in-game. It reads the building registry safety classes, confirmation phrases, project-local write scopes, File Vault allowlist, recent memory events, terminal logs, permission receipts, and a bounded secret exposure audit. The secret audit scans only allowlisted project-local examples, caches, dispatches, and logs; it reports counts, source paths, and line numbers without returning matched secret text, and skips known safe placeholders/redacted markers. It is intentionally read-only and does not grant new capabilities.

Settings Center makes configuration visible in-game. It inspects active JSON registries, startup launchers, model profile environment requirements, and project-local settings drafts. It never returns raw secret values and writes only review drafts under `workspace/settings-drafts`.

Testing Arena makes verification visible in-game. It inspects the smoke scripts, latest visual smoke artifact, all-room screenshot manifest integrity, recent terminal logs, and verification history from `PLAN.md`, then lets the player create project-local test-plan drafts under `workspace/test-plans`. It does not execute commands directly.

Bug Clinic makes diagnostics visible in-game. It inspects failed backend jobs, failed Terminal Control logs, diagnostic memory events, and known issues, then lets the player create project-local bug-report drafts under `workspace/bug-reports`. It does not edit code or apply fixes.

Project Management Hall makes the portfolio visible in-game. It aggregates local Git projects, research boards, task status, and Git dock counts, then lets the player create project-local brief drafts under `workspace/project-briefs` without mutating repos or trackers.

Download Station makes downloaded files and imported assets visible in-game. It shallowly inspects allowlisted roots such as the user's Downloads folder, D-drive download folders, project art, and asset intake staging, classifies recent files, and lets the player create project-local intake drafts under `workspace/download-intake`. It does not move, delete, open, execute, install, or fetch files.

Asset Resource Gallery makes the visual production pipeline visible in-game. It performs bounded allowlisted inspection of `godot/assets`, source art, legacy generated assets, visual baseline docs, screenshots, and `workspace/asset-notes`, then lets the player create project-local curation notes under `workspace/asset-notes`. It does not edit, move, delete, copy, import, optimize, generate, or publish assets; it is a safe staging surface before real art promotion.

Local Office Center makes office-style work visible in-game. It boundedly inspects `D:\Company`, project docs, writing drafts, project briefs, and `workspace/office-notes`, then lets the player create project-local follow-up notes under `workspace/office-notes`. It does not edit, move, delete, open, email, upload, sync, or otherwise mutate company/source files; follow-ups can later be routed to Task Board, Project Management Hall, Writing Studio, or Temporary Draft Box.

Schedule and Plan Center makes local planning visible in-game without becoming an external calendar manager. It reads lightweight signals from `PLAN.md`, `MEMORY.md`, Task Board status, office notes, and selected shared-memory files, then creates schedule drafts under `workspace/schedules`. It does not edit calendars, install schedulers, start jobs, stop services, change trackers, or notify external systems; real execution remains routed through Task Board or confirm-required tools.

Learning Training Grounds makes self-improvement and skill practice visible in-game. It reads the local skill index, architecture/visual docs, selected shared-memory workflow rules, and schedule drafts, then creates learning plans under `workspace/learning-plans`. It does not install skills, run commands, invoke agents, edit shared memory, enroll external courses, or change schedules; plans are local staging artifacts before practice becomes a task or schedule item.

Language Learning Area makes multilingual practice visible in-game without turning the client into an external translation service. It reads local UI/language signals from README/docs/Godot notes and creates phrase-practice notes under `workspace/language-practice`. It does not call translators, external APIs, agents, calendars, or edit source UI/documentation; wording promotion remains a manual review step.

Research Data Center makes research data provenance visible in-game. It boundedly scans configured `D:\Research` project roots for likely data, result, run, log, table, figure, and checkpoint artifacts, then creates local audit notes under `workspace/research-data-notes`. It does not launch experiments, mutate datasets, upload files, contact servers, or promote claims; execution still belongs behind ARIS plans and explicit gates.

Paper Reading Room makes literature review and citation hygiene visible in-game. It boundedly scans allowlisted roots for PDFs, BibTeX files, manuscripts, and notes, creates local reading/citation-audit notes under `workspace/paper-reading-notes`, and can run a bounded BibTeX metadata audit for duplicate keys plus missing `title`, `author`, `year`, and venue-like fields. It follows ARIS citation-audit prompts for completeness, fairness, recency, and BibTeX quality, while avoiding large PDF parsing on the Godot main thread, bibliography edits, downloads, search APIs, or research-folder mutation.

Version Release Plaza makes the open-source publishing path visible in-game. It checks local release-readiness artifacts such as README, LICENSE, CONTRIBUTING, SECURITY, ROADMAP, architecture docs, visual baseline, screenshots, the all-room visual manifest, Godot build/export readiness, export-tool reports, packaged-launch readiness, release package hashes, smoke logs, and Git status, then creates release checklist drafts under `workspace/release-drafts`. It does not stage, commit, tag, push, open PRs, create releases, overwrite docs, run exports, launch packaged sessions, zip artifacts, kill processes, or change remotes; those remain future confirm-required workflows.

The baseline public release artifacts now exist: `LICENSE`, `CONTRIBUTING.md`, `SECURITY.md`, and `ROADMAP.md`, alongside README, architecture docs, visual baseline, and screenshot evidence. Version Release Plaza treats these as required release-readiness inputs rather than final public-release approval.

Plugin Registry makes the extension system visible in-game before real plugin installation exists. It boundedly inventories local manifests, Godot scripts, backend adapters, docs, tools, agent resources, and knowledgebase skills, reports runtime registry status for buildings/agents/model profiles/workspaces, audits typed extension manifests from `godot/data/plugin_manifests.json`, and creates plugin proposal drafts under `workspace/plugin-drafts`. Activation is still review-only: `POST /api/plugin-registry/activation-plans` requires `PLAN_PLUGIN_ACTIVATION` before writing a project-local review plan with permissions, files, endpoints, verification, and rollback notes. It does not install plugins, run package managers, execute scripts, edit registries, download assets, change skills, invoke agents, or activate code; promotion into implementation remains a separate verified slice.

Backup Station makes backup and restore planning visible in-game. It shallowly inspects critical source folders such as the AI Town repo, shared memory, Godot registries, docs, and workspace, plus candidate target folders such as `D:\Backups`, project backup staging, and devtools backups. It creates project-local backup plan drafts under `workspace/backup-plans` and does not copy, delete, compress, restore, schedule, upload, or prune files.

Long-Term Goal Tower makes the project's long-horizon direction visible in-game. It reads open and completed items from `PLAN.md`, selected shared-memory signals, Task Board status counts, and Project Management Hall portfolio counts, then creates project-local goal drafts under `workspace/goals`. It does not mutate trackers, repositories, experiments, schedules, or agent runners.

Inspiration Collection Station makes loose ideas visible in-game before they become tasks or roadmap items. It reads project docs, the visual baseline, architecture notes, selected shared-memory status, and nearby project-local drafts, then creates inspiration notes under `workspace/inspiration`. It does not edit source docs, shared memory, trackers, repositories, assets, or agent runners.

Temporary Draft Box makes project-local drafts visible as an inbox before they become real work items. It inventories draft shelves under `workspace`, creates scratch notes under `workspace/temp-drafts`, and records a memory event. It does not promote, delete, route, overwrite, or send drafts to agents or external tools.

## Persistent Local Task Ledger

The first safe execution-like workflow is Code Workshop task drafting:

- `POST /api/projects/{project_id}/code-task-draft`
- writes a Markdown task draft under `workspace/tasks`
- updates `workspace/tasks/tasks.json`
- records a local memory event under `workspace/memory-events`

This gives the game a real task state and memory trail while keeping external repositories untouched.

## Target Module Split

```text
backend/
  main.py                 # temporary composition root
  api/                    # route modules
  adapters/               # memory, research, file, git, devtools, agent hub
  agents/                 # roster, task queue, runner integration
  permissions/            # safety classes, confirmation, audit log
  config/                 # registry loading and validation
  logs/                   # execution/action logs

godot/
  scenes/
    main.tscn
    rooms/
  scripts/
    main.gd               # temporary composition root
    api_client.gd
    world/
    ui/
    quests/
    rooms/
    data/
      buildings.json         # first active building registry
      agents.json            # first active agent registry
      workspaces.json        # allowlisted local workspace registry
      quests.json            # playable quest registry
```

## Near-Term Milestones

1. Stabilize the vertical slice:
   player movement -> enter building -> inspect real data -> request safe agent/task action -> see result -> record progress.
2. Extend quest chains beyond orientation into project-specific story arcs and safe execution arcs.
3. Split monolithic backend and Godot scripts into modules.
4. Expand GitHub Harbor publish plans into future write workflows for push, PR, tag, and release operations, with explicit user approval, diff preview, fresh verification evidence, and rollback notes.
5. Expand Terminal Control from project-local verification commands into broader dry-run, allowlist, logs, pause/resume, and rollback-aware workflows.
6. Expand Plugin Registry activation plans into a future implementation workflow that can apply reviewed manifests behind stronger confirmation, diff preview, smoke, rollback, and visual proof gates.
7. Prepare GitHub release hygiene: README rewrite, license, screenshots, security notes, contribution guide.
