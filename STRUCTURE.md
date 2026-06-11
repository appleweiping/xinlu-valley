# Agent Town Godot Structure

Updated: 2026-05-30

## Runtime Layout

- `godot/` — active Godot 4 client.
- `backend/` — FastAPI local data and dialogue bridge.
- `frontend/` — legacy React/Phaser reference implementation.
- `tools/godot/` — local pinned Godot editor/runtime downloaded inside this D-drive project and intentionally ignored by git.
- `start.cmd` — launches the backend and Godot client from this repository path.
- `start-godot.cmd` — launches only the Godot client.
- `start-backend.cmd` — launches only the FastAPI bridge.
- `tools/verify-smoke.ps1` — non-invasive verification for Python compile, FastAPI read-only endpoints, and Godot headless startup.
- `tools/capture-visual-smoke.ps1` — opens Godot briefly in render mode, captures `screenshots/visual-smoke.png`, and exits automatically.
- `tools/capture-room-visuals.ps1` — captures regression screenshots for File Vault, Research Hall, Code Workshop, Agent Hub, and Testing Arena into `screenshots/room-*.png`.
- `screenshots/map-plaza.png` — map-level visual proof for data-driven Central Plaza landmarks, captured with `AGENT_TOWN_CAPTURE_ROOM=map`.
- `LICENSE` — MIT license for open-source distribution.
- `CONTRIBUTING.md` — contributor setup, safety rules, and PR checklist.
- `SECURITY.md` — local-first security boundaries and vulnerability reporting guidance.
- `ROADMAP.md` — phased long-term plan for the Godot rebuild, real workflow buildings, architecture hardening, art pass, agent operations, and release.
- `godot/data/workspaces.json` — allowlisted workspace registry for File Vault roots, project discovery, and future plugin expansion.
- `godot/data/quests.json` — playable work quest registry with chapters, target buildings, steps, rewards, and local status templates.
- `godot/data/npc_quests.json` — room NPC quest-chain registry for named room arcs, stages, rewards, and safety notes.
- `godot/data/districts.json` — map district and teleport registry used by the Godot client and `/api/config/districts`.
- `godot/data/room_scenes.json` — room interior station layout registry for clickable safe-action hotspots.
- `godot/data/map_decor.json` — clickable Central Plaza landmark registry for quest, route, agent, portal, and building hub actions.
- `workspace/agent-task-logs/` — ignored local JSON logs for safe Agent Task Queue runs.
- `workspace/agent-tool-logs/` — ignored local JSON logs for safe Agent Tool Registry invocations.
- `workspace/knowledge-index/` — ignored local cache for allowlisted Knowledge Tower search.
- `workspace/file-vault-index/` — ignored local cache and tag ledger for File Vault search.
- `workspace/file-organize-drafts/` — ignored local Markdown proposals for File Vault organization plans; source files are not moved or modified.
- `workspace/code-patch-plans/` — ignored local Code Workshop patch-plan handoffs; selected repositories are not edited by the endpoint.
- `workspace/project-verification-logs/` — ignored JSON logs for confirm-required Code Workshop verification jobs.
- `workspace/backend-job-logs/` — ignored JSON lifecycle logs for backend queued jobs, cancellation requests, failures, and result evidence.
- `workspace/github-harbor-drafts/` — ignored local GitHub Harbor PR/issue/release handoff drafts; Git and GitHub are not written by the endpoint.
- `workspace/research-logs/` — ignored local Research Hall Markdown logs; selected research repositories are not modified by the endpoint.
- `workspace/release-readiness-reports/` — ignored local Version Release Plaza reports linking public artifact, Git, proof, Harbor, and safety receipt evidence without Git/GitHub writes.
- Godot player profile `user://agent_town_save.json` stores local-only quest state, NPC quest-chain progress, badge state, recruited companions, claimed Daily Routes, visited route buildings, route completion state, Room Mastery, and recent Activity Log entries.

## Godot Client

- `godot/project.godot` defines the Godot app.
- `godot/scenes/main.tscn` loads `scripts/main.gd`.
- `godot/scripts/main.gd` builds the current scene dynamically:
  - town map background
  - player movement and camera
  - resident agent sprites
  - building interaction zones
  - HUD/detail/dialogue UI, including Waypoint and Activity Log panels
  - HTTP requests to the backend

## Backend Contract

Current live endpoints used by the Godot client:

- `GET /api/health`
- `GET /api/buildings/{building_id}`
- `POST /api/dialogue`
- `GET /api/workbench/quests`
- `GET /api/workbench/daily-routes`
- `POST /api/workbench/action`
- `GET /api/workbench/rooms/{building_id}`
- `GET /api/research/projects`
- `GET /api/research/projects/{project_id}`
- `POST /api/research/projects/{project_id}/logs`
- `GET /api/memory/index`
- `GET /api/memory/items/{category}`
- `GET /api/memory/items/{category}/{filename}`
- `POST /api/memory/proposals`
- `GET /api/knowledge/index`
- `POST /api/knowledge/index-job`
- `GET /api/knowledge/search`
- `GET /api/knowledge/items/{doc_id}`
- `GET /api/agent-hub/overview`
- `GET /api/agent-hub/roster`
- `GET /api/agent-hub/companions`
- `GET /api/agent-hub/mailboxes`
- `POST /api/agent-hub/dispatch-drafts`
- `GET /api/agent-chat/sessions`
- `POST /api/agent-chat/sessions`
- `GET /api/agent-chat/sessions/{session_id}`
- `POST /api/agent-chat/sessions/{session_id}/messages`
- `GET /api/agent-tasks/queue`
- `POST /api/agent-tasks/submit`
- `GET /api/agent-tasks/{task_id}`
- `GET /api/agent-tasks/{task_id}/events`
- `POST /api/agent-tasks/{task_id}/pause`
- `POST /api/agent-tasks/{task_id}/resume`
- `GET /api/agent-tools/catalog`
- `GET /api/agent-tools/invocations`
- `POST /api/agent-tools/invoke`
- `GET /api/agent-tools/invocations/{invocation_id}`
- `GET /api/agent-tools/invocations/{invocation_id}/events`
- `GET /api/config/buildings`
- `GET /api/config/agents`
- `GET /api/config/workspaces`
- `GET /api/config/quests`
- `GET /api/config/npc-quests`
- `GET /api/config/room-scenes`
- `GET /api/config/map-decor`
- `GET /api/config/registry-health`
- `GET /api/player/collection-codex`
- `GET /api/config/districts`
- `GET /api/projects`
- `GET /api/projects/{project_id}`
- `POST /api/projects/{project_id}/inspect-job`
- `POST /api/projects/{project_id}/code-task-draft`
- `POST /api/projects/{project_id}/context-pack`
- `POST /api/projects/{project_id}/patch-plan`
- `GET /api/jobs/{job_id}`
- `GET /api/jobs/{job_id}/events`
- `GET /api/github-harbor/repos`
- `GET /api/github-harbor/repos/{project_id}`
- `GET /api/github-harbor/repos/{project_id}/github`
- `POST /api/github-harbor/repos/{project_id}/drafts`
- `GET /api/terminal/commands`
- `POST /api/terminal/run`
- `GET /api/system/overview`
- `GET /api/system/jobs`
- `GET /api/system/job-logs`
- `GET /api/system/job-logs/{log_id}`
- `GET /api/system/events`
- `GET /api/model-gateway/status`
- `GET /api/model-gateway/profiles`
- `POST /api/model-gateway/chat`
- `POST /api/model-gateway/profile-tests`
- `POST /api/model-gateway/config-drafts`
- `GET /api/file-vault/roots`
- `GET /api/file-vault/list/{root_id}`
- `GET /api/file-vault/preview/{root_id}`
- `GET /api/file-vault/index`
- `POST /api/file-vault/index-job`
- `GET /api/file-vault/search`
- `POST /api/file-vault/tags`
- `POST /api/file-vault/open`
- `POST /api/file-vault/organize-proposals`
- `GET /api/task-board/overview`
- `POST /api/task-board/tasks`
- `GET /api/task-board/tasks/{task_id}`
- `PATCH /api/task-board/tasks/{task_id}`
- `GET /api/writing-studio/overview`
- `POST /api/writing-studio/drafts`
- `GET /api/automation-factory/overview`
- `GET /api/automation-factory/scheduler`
- `POST /api/automation-factory/drafts`
- `GET /api/download-station/overview`
- `GET /api/download-station/triage`
- `POST /api/download-station/intake-drafts`
- `GET /api/asset-gallery/overview`
- `GET /api/asset-gallery/inspect`
- `POST /api/asset-gallery/notes`
- `GET /api/local-office-center/overview`
- `POST /api/local-office-center/notes`
- `GET /api/schedule-plan-center/overview`
- `POST /api/schedule-plan-center/drafts`
- `GET /api/learning-training-grounds/overview`
- `POST /api/learning-training-grounds/plans`
- `GET /api/language-learning-area/overview`
- `POST /api/language-learning-area/practice`
- `GET /api/research-data-center/overview`
- `POST /api/research-data-center/notes`
- `GET /api/paper-reading-room/overview`
- `POST /api/paper-reading-room/notes`
- `POST /api/paper-reading-room/extract-jobs`
- `GET /api/version-release-plaza/overview`
- `POST /api/version-release-plaza/checklists`
- `POST /api/version-release-plaza/reports`
- `GET /api/plugin-registry/overview`
- `POST /api/plugin-registry/drafts`
- `GET /api/backup-station/overview`
- `GET /api/backup-station/integrity`
- `POST /api/backup-station/plans`
- `GET /api/goal-tower/overview`
- `POST /api/goal-tower/goals`
- `GET /api/inspiration-station/overview`
- `POST /api/inspiration-station/notes`
- `GET /api/temporary-draft-box/overview`
- `POST /api/temporary-draft-box/drafts`
- `GET /api/town/capability-atlas`
- `GET /api/town/capability-atlas/{building_id}`
- `GET /api/town/workflow-routes`
- `GET /api/town/workflow-routes/{route_id}`

Implemented building IDs:

- `memory-library`
- `skill-workshop`
- `knowledge-tower`
- `devtools-lab`
- `town-hall`
- `file-vault`
- `research-hall`
- `agent-hub`
- `resource-market`
- `code-workshop`
- `github-harbor`
- `terminal-control`
- `system-monitor`
- `model-market`
- `task-board`
- `writing-studio`
- `download-station`
- `asset-gallery`
- `local-office-center`
- `schedule-plan-center`
- `learning-training-grounds`
- `language-learning-area`
- `research-data-center`
- `paper-reading-room`
- `version-release-plaza`
- `plugin-registry`
- `backup-station`
- `goal-tower`
- `inspiration-station`
- `temporary-draft-box`

The Godot client tolerates unavailable endpoints and shows honest fallback text instead of fake real data.

## Quest Registry

`godot\data\quests.json` is the first data-driven progression registry. It defines:

- quest id/title/chapter/giver
- target building
- safe summary text or live summary templates
- ordered steps such as accept, enter room, review shelves, and scan
- badge reward, collection, and next hint
- safety class

The backend resolves lightweight templates such as memory counts, skill counts, and workspace counts, then exposes the active set through `GET /api/config/quests` and `GET /api/workbench/quests`. Godot keeps local fallback quest data from the same registry so the town can still show playable progression if the backend quest endpoint is unavailable. Accepted/completed quest state and badge rewards remain local Godot save data.

`godot\data\npc_quests.json` is the data-driven NPC quest-chain registry. It defines named room arcs with NPC, chapter, summary, stage list, reward, and safety class for key work rooms including File Vault, Research Hall, Code Workshop, Agent Hub, Testing Arena, Memory Library, Knowledge Tower, GitHub Harbor, Terminal Control, Model Market, and Paper Reading Room. The backend exposes it through `GET /api/config/npc-quests`, Settings Center and Plugin Registry list it as a read-only registry, and Godot renders matching chains inside room panels. Godot records successful stage actions into local `npc_chain_progress`, shows stage checkboxes and completion state, and awards `NPC Chains` badges in the local player profile. The chains only observe existing safe actions; they do not execute extra work or mutate project files.

`godot\data\room_scenes.json` is the data-driven room-scene registry. It defines interior room title, ambient text, floor path, props, station rectangles, station labels, station roles, and station action IDs for eleven key rooms: File Vault, Research Hall, Code Workshop, Agent Hub, Testing Arena, Memory Library, Knowledge Tower, GitHub Harbor, Terminal Control, Model Market, and Paper Reading Room. The backend exposes it through `GET /api/config/room-scenes`, and Settings Center, Plugin Registry, and System Monitor list it as read-only runtime configuration. Godot loads the same file locally and turns station entries into clickable room-stage buttons that call existing safe UI actions; the registry does not grant new permissions.

`godot\data\map_decor.json` is the first data-driven Central Plaza landmark registry. It defines clickable plaza objects such as Memory Fountain, Quest Board, Daily Routes, Agent Gate, portal, Code Path, and Memory Crystal with positions, sizes, colors, descriptions, and safe action IDs. The backend exposes it through `GET /api/config/map-decor`, and Settings Center, Plugin Registry, and System Monitor list it as read-only runtime configuration. Godot loads the same file locally and turns entries into clickable map hotspots for in-game routing, quest refresh, daily-route loading, badge refresh, agent selection, or building selection.

`GET /api/config/registry-health` validates the current Godot registry files without writing to them. It parses the building, agent, model profile, workspace, quest, NPC quest-chain, room-scene, map-decor, district, and workflow-route registries; checks required fields, duplicate IDs, top-level array shape, and child stage/station/route-step fields; and returns aggregate `ok`/`warning`/`error` status. Settings Center exposes this through the `Registry Health` control, while System Monitor and Plugin Registry include the same summary for architecture hardening.

`GET /api/player/collection-codex` is the first read-only collection catalog. It combines possible rewards from the Quest Registry, NPC quest-chain registry, building registry, Daily Route generator, and Agent companion metadata into collectible sets for Quest Badges, NPC Chain Badges, Room Mastery, Daily Routes, and Agent Companions. Godot's Quest Board `Codex` control merges this catalog with local `user://agent_town_save.json` ownership/progress. The endpoint does not mutate player saves, files, agents, commands, Git state, or external services.

## Agent Task Queue

Agent Hub now exposes a safe local task queue through `GET /api/agent-tasks/queue`, `POST /api/agent-tasks/submit`, `GET /api/agent-tasks/{task_id}`, `GET /api/agent-tasks/{task_id}/events`, `POST /api/agent-tasks/{task_id}/pause`, and `POST /api/agent-tasks/{task_id}/resume`. Current task types are `memory-brief`, `project-brief`, `workspace-brief`, `code-review-brief`, `code-explain-brief`, `research-brief`, and `task-brief`; they build bounded read-only local summaries, can be submitted paused and resumed, and write JSON logs under `workspace\agent-task-logs`. Godot caches the queue cards, cycles the selected task with `Next Result`, renders full task detail/result payloads with `Open Result`, controls selected queued work with `Pause Task` / `Resume Task`, and polls bounded incremental task events with `Task Events`. The queue never launches external agent runners, stops services, or runs arbitrary shell commands.

## Agent Chat

Agent Hub now exposes persistent Agent Chat sessions through `/api/agent-chat/sessions`. Sessions are JSON logs under `workspace\agent-chats`; messages are appended with local context summaries, safe tool suggestions, and memory events. Godot stores the latest suggested registered tools and `Run Suggested` can queue the first suggestion through the safe Agent Tool Registry with conservative parameters. This gives the Godot client a durable conversation surface before write-capable external runners are enabled. It does not execute shell commands or mutate source repositories.

## Agent Tool Registry

Agent Hub also exposes a safe tool invocation layer through `GET /api/agent-tools/catalog`, `POST /api/agent-tools/invoke`, `GET /api/agent-tools/invocations`, `GET /api/agent-tools/invocations/{invocation_id}`, and `GET /api/agent-tools/invocations/{invocation_id}/events`. Current tools are `memory-index`, `knowledge-search`, `file-search`, `project-index`, and `system-snapshot`. Each invocation runs through the backend job executor, records status/result/error, writes a JSON log under `workspace\agent-tool-logs`, and records a project-local memory event. Godot caches recent invocations, cycles them with `Next Tool`, renders full invocation details with `Open Tool`, and polls incremental invocation events with `Tool Events`. This is the first real adapter layer for future coding/research agents; it does not invoke external agent runners or arbitrary shell commands.

## Knowledge Index

Knowledge Tower now uses an allowlisted cached index instead of recursive live scans. `POST /api/knowledge/index-job` refreshes `workspace\knowledge-index\knowledge-index.json` through the backend job queue; `GET /api/knowledge/index` reads cache status; `GET /api/knowledge/search` returns paginated cached matches; `GET /api/knowledge/items/{doc_id}` returns a bounded preview for one indexed document. Current roots include the shared knowledge base, shared memory, AI Town docs/root docs, and agent resources. Ignored directories include `.git`, virtualenvs, `node_modules`, Godot import folders, build outputs, and cache folders.

## Current Gameplay Loop

1. Player walks around the town map.
2. Player accepts a registry-backed local work quest from the Quest Board.
3. Player selects or enters the target building.
4. Room panel opens with an NPC, atmosphere text, a workbench, and building-specific shelf cards.
5. Player runs `Do Safe Work Scan`.
6. Backend performs a read-only scan for that building.
7. Quest completes and grants a lightweight reward label.
8. Reward is saved into the local Badge Case via `user://agent_town_save.json`.
9. In key rooms, NPC quest-chain stages are marked by successful safe actions such as roots, previews, research logs, code task drafts, agent event review, test-plan drafts, memory proposals, knowledge searches, GitHub status checks, command previews, model profile tests, and paper reading notes.
10. Completed NPC chains award local `NPC Chains` badges without launching agents, running commands, or editing source files.
11. In the first room-scene interiors, player clicks station hotspots inside the room stage to trigger those same safe actions from the visual scene.
12. In Central Plaza, player clicks landmark hotspots such as Quest Board, Daily Routes, Agent Gate, Memory Fountain, or Code Path to navigate safe hub actions directly from the map.
13. The Waypoint panel updates with the selected landmark, district, building, agent, or Daily Route stop and shows live distance from the player.

This is the first playable proof of "do local work while playing"; future work should replace overlay room focus with dedicated Godot room scenes and richer interaction.

## Room Presentation

The current room implementation is still UI-driven, but no longer text-only. Godot renders a procedural room stage inside the room panel:

- room-colored wall and floor path
- NPC marker
- workbench marker
- up to four shelf-card markers from backend room cards
- action strip for read/draft/confirm flow

This is a stepping stone toward dedicated Godot room scenes.

## Visual Evidence

`screenshots/visual-smoke.png` is the quick proof artifact for the File Vault room UI. It is captured through normal Godot rendering because headless/dummy rendering cannot provide a viewport texture.

`tools\capture-room-visuals.ps1` uses the same non-headless capture path with `AGENT_TOWN_CAPTURE_ROOM` and writes multiple room regression artifacts:

- `screenshots\room-file-vault.png`
- `screenshots\room-research-hall.png`
- `screenshots\room-code-workshop.png`
- `screenshots\room-agent-hub.png`
- `screenshots\room-testing-arena.png`

The current Godot client includes an early storybook UI pass: parchment panels, warm wood/gold buttons, brown ink text, plaza cues, building sign trim, and softer room-stage colors. This is an implementation step toward `docs\VISUAL_BASELINE.md`, not the final art pass.

## Research Hall

The Research Hall is the first deeper "real work" building. It reads bounded, read-only data from `D:\Research` and shared memory status files, then exposes project boards for:

- Pony / Uncertainty
- TGL-Rec
- TRUCE-Rec
- ProteinShift / DA-BCP
- CSATG-EDA
- DoneBench
- AgentMemory

Each project board can return local roots, status documents, server notes, next actions, and likely experiment entry candidates such as README files, run scripts, configs, and result folders. The Godot room has `Research Projects` and `Project Detail` controls for this flow.

Research Hall also has a safe `Research Agent` path. Godot submits `research-brief` tasks to `/api/agent-tasks/submit` with the selected research `project_id`. The backend builds an ARIS-style read-only project brief with status docs, local directories, experiment candidates, risks, recommended next steps, JSON logs, and memory events. It does not run experiments, contact servers, mutate datasets, or edit research repos.

The `Research Log` control writes selected project board snapshots to `POST /api/research/projects/{project_id}/logs`. Drafts are Markdown files under `workspace\research-logs` with local roots, status excerpts, experiment candidates, safety checklist, next safe actions, and a local memory event. This path never writes into `D:\Research`, starts experiments, contacts servers, mutates datasets, or edits research repositories.

## Memory Library

The Memory Library reads the real shared memory root at `D:\research\Vipin's Knowledgebase\memory` and exposes it as game shelves:

- decisions
- facts
- lessons
- preferences
- sessions
- workflows

The backend returns category counts, recent notes, agent-related notes, live AgentMemory service status when reachable, and bounded Markdown previews. The Godot room has `Memory Shelves` and `Memory Detail` controls for this flow.

Memory Library also supports project-local memory proposals through `POST /api/memory/proposals`. Proposals are written under ignored `workspace\memory-proposals` with category, tags, target hint, review checklist, and a local memory event. Reviewed proposals can then be promoted through `POST /api/memory/promotions`: the first request returns a bounded preview and the required `PROMOTE_MEMORY` phrase, and only the confirmed second request writes into `D:\research\Vipin's Knowledgebase\memory`. Each confirmed promotion also writes a project-local receipt under `workspace\memory-promotions` and appears in Permission Hall safety receipts.

## Workspace Registry

`godot\data\workspaces.json` is the first dynamic workspace registry. It currently declares seven allowlisted roots:

- `D:\Research`
- `D:\Game_develop`
- `D:\Company`
- `D:\research\Vipin's Knowledgebase`
- `D:\agent-resources`
- `D:\devtools`
- the AI Town project root

Each workspace can opt into File Vault browsing and project discovery separately. The backend exposes the active registry at `GET /api/config/workspaces`, uses it for File Vault roots, uses project-enabled entries for Code Workshop project discovery, and surfaces the same status in Settings Center, System Monitor, and Plugin Registry. If the registry file is missing or malformed, the backend falls back to the previous built-in allowlist.

## File Vault

The File Vault is the first real file-browser room. It uses the workspace registry instead of arbitrary paths:

- `D:\Research`
- `D:\Game_develop`
- `D:\Company`
- `D:\research\Vipin's Knowledgebase`
- `D:\agent-resources`
- `D:\devtools`
- the AI Town project root

The backend exposes registry-backed roots, lazy directory pages, bounded small-text previews, cached search, project-local tags, and allowlisted local reveal/open actions. It rejects path traversal, keeps every target inside its root, avoids recursive startup scans, and blocks large/binary previews. `POST /api/file-vault/index-job` refreshes `workspace\file-vault-index\file-vault-index.json` through the backend job queue using shallow per-root limits. `POST /api/file-vault/tags` writes only to `workspace\file-vault-index\file-tags.json`; source files and folders are never modified. `POST /api/file-vault/open` can reveal an allowlisted file/folder in Explorer or open a file with its default local app, records a memory event, supports dry-run verification, and never edits file contents. The Godot room has `File Roots`, `File Index`, `Search Files`, `Tag File`, `Open Folder`, `Reveal Item`, and `Preview File` controls.

## Research Data Center

Research Data Center is the first dataset/result provenance room. It boundedly scans configured research project roots from `D:\Research` for likely data, result, run, log, table, figure, and checkpoint artifacts. It returns candidate type counts, per-project root status, and audit prompts for provenance/schema/metric checks.

Creating a research data note writes a Markdown file under `workspace\research-data-notes` and records a local memory event. It does not launch experiments, edit datasets, upload files, contact servers, or promote claims into papers automatically.

## Paper Reading Room

Paper Reading Room is the first literature/citation workflow room. It boundedly inspects allowlisted roots such as `D:\Research`, the shared knowledge base, project docs, and local reading notes for likely PDFs, BibTeX files, manuscripts, and paper notes. It returns candidate type counts, root status, and citation-audit reading loops.

Creating a paper reading note writes a Markdown file under `workspace\paper-reading-notes` and records a local memory event.

`POST /api/paper-reading-room/extract-jobs` queues bounded PDF text extraction through the backend job system. The request resolves only allowlisted root IDs plus relative paths from the paper map, defaults to the first discovered PDF when none is specified, limits extraction to 1-8 pages and 50 MB, writes Markdown reports under `workspace\paper-extraction-reports`, and records a local memory event. It uses `pypdf` when installed from `backend\requirements.txt` and otherwise returns a report with parser-availability warnings. It does not run on the Godot main thread, edit PDFs, edit bibliographies, download papers, call search APIs, mutate research folders, or change Git state.

## Version Release Plaza

Version Release Plaza is the first open-source release-readiness room. It inspects the public release artifact set:

- `README.md`
- `LICENSE`
- `CONTRIBUTING.md`
- `SECURITY.md`
- `ROADMAP.md`
- architecture and visual baseline docs
- `screenshots\visual-smoke.png`
- current Git branch, remotes, tags, and short status

Creating a release checklist writes a Markdown file under `workspace\release-drafts` and records a local memory event. It does not stage, commit, tag, push, open PRs, create releases, overwrite docs, or change remotes.

Creating a release readiness report writes a Markdown file under `workspace\release-readiness-reports` and records a local memory event. The report links the public artifact set, Git status, visual/smoke evidence, Testing Arena vertical-slice proof reports, GitHub Harbor local repo docks, and Permission Hall safety receipts. It does not stage, commit, tag, push, open PRs, create releases, overwrite docs, call GitHub APIs, or change remotes.

As of the release artifact slice, the required public artifact set exists and Version Release Plaza reports 8/8 required artifacts ready. The files are still living documents; future release work should refine them as the project moves from local preview to public GitHub release.

## Plugin Registry

Plugin Registry is the first extension-system room. It boundedly inventories local extension candidates from:

- `godot\data`
- `godot\scripts`
- `backend`
- `tools`
- `docs`
- `D:\agent-resources`
- `D:\research\Vipin's Knowledgebase\.codex\skills`
- `workspace\plugin-drafts`

It reports runtime registry status for buildings, agents, model profiles, and workspaces, classifies candidate manifests/scripts/docs/skills/config files, and creates plugin proposal drafts under `workspace\plugin-drafts`. It does not install plugins, run package managers, execute scripts, edit registries, download assets, change skills, or invoke agents.

## Task Board

Task Board is the first unified real-task surface. It reads:

- `workspace\tasks\tasks.json`
- Markdown task drafts under `workspace\tasks`
- Agent dispatch drafts under `workspace\agent-dispatch`
- Local memory events under `workspace\memory-events`

The backend exposes task overview, project-local task creation, bounded task preview, project-local task status update endpoints, and a bridge into Agent Task Queue `task-brief`. Creating a task writes a Markdown draft, updates the task ledger, and records a local memory event. Preview reads only the selected task's project-local draft and returns a bounded text preview. Updating status changes only the project-local ledger and task draft history, then records a local memory event. Task Agent creates a safe read-only queue item for the selected task. It does not invoke an external agent runner, execute commands, update external trackers, open external programs, or modify any external repository.

## Writing Studio

Writing Studio is the first document-writing room. It indexes the active project docs and local drafts:

- `README.md`
- `PLAN.md`
- `STRUCTURE.md`
- `MEMORY.md`
- `ASSETS.md`
- `docs\*.md`
- `godot\README.md`
- `workspace\drafts`

Creating a writing draft writes a Markdown file under `workspace\drafts` and records a local memory event. It does not overwrite project docs or write to shared memory directly.

## Automation Factory

Automation Factory is the first local automation planning room. It catalogs known project scripts and launchers:

- `tools\verify-smoke.ps1`
- `tools\capture-visual-smoke.ps1`
- `start.cmd`
- `start-backend.cmd`
- `start-godot.cmd`
- `stop.cmd` as blocked/manual-only visibility

The backend exposes script catalog, read-only scheduler snapshot, and blueprint creation endpoints. `GET /api/automation-factory/scheduler` runs a fixed bounded Windows Scheduled Tasks query and returns task name/path/state/description samples. Creating an automation blueprint writes under `workspace\automation-drafts` and records a local memory event. It does not run scripts, install scheduled tasks, create/enable/disable/delete scheduled tasks, stop services, or modify external processes. Future activation should route through a confirm-required runner with logs, rollback notes, and pause/resume state.

## Permission Hall

Permission Hall is the first safety and policy room. It is read-only and explains the current operating boundary:

- building safety classes from `godot\data\buildings.json`
- confirmation phrases for draft saving and Terminal Control
- project-local writable scopes under `workspace\`
- File Vault allowlisted roots
- blocked/future-gated actions such as raw shell, scheduler install, service shutdown, destructive file edits, and external Git writes
- recent local audit signals from `workspace\memory-events` and `workspace\terminal-logs`
- read-only permission receipts from terminal logs, model tests, memory events, agent task/tool logs, and local tasks

The backend exposes `GET /api/permissions/overview` and `/api/buildings/permission-hall`. This does not grant new permissions; it makes the existing rules visible inside the game.

`GET /api/permissions/receipts` returns the same local safety evidence as a standalone read-only ledger. Receipt classes include confirmed allowlisted commands, no-secret model profile tests, project-local memory/write events, safe agent tasks, safe registered tool invocations, and local task status changes. The receipt view does not run commands, modify files, open arbitrary logs, grant permissions, or contact external services.

## Settings Center

Settings Center is the first configuration-management room. It inspects:

- `godot\data\buildings.json`
- `godot\data\agents.json`
- `godot\data\model_profiles.json`
- project launchers such as `start.cmd`, `start-backend.cmd`, and `start-godot.cmd`
- environment variable requirements for model/API profiles, showing names and configured/missing status only
- project-local draft folders

The backend exposes `GET /api/settings-center/overview` and `POST /api/settings-center/drafts`. Draft creation writes only under `workspace\settings-drafts` and records a local memory event. It does not write raw API keys, edit live registries, edit launchers, or mutate the process environment.

## Testing Arena

Testing Arena is the first verification room. It reads:

- `tools\verify-smoke.ps1`
- `tools\capture-visual-smoke.ps1`
- `screenshots\visual-smoke.png`
- recent Terminal Control logs under `workspace\terminal-logs`
- recent verification entries from `PLAN.md`
- project-local test-plan drafts under `workspace\test-plans`
- project-local vertical-slice proof reports under `workspace\vertical-slice-proofs`

The backend exposes `GET /api/testing-arena/overview`, `POST /api/testing-arena/test-plans`, `POST /api/testing-arena/vertical-slice-proofs`, and `GET /api/testing-arena/vertical-slice-proofs/{proof_id}`. Draft/report creation writes only Markdown files and records local memory events. It does not run commands; execution remains in Terminal Control or explicit developer verification.

Vertical-slice proof reports summarize existing evidence for the playable local-work loop: registries, map/district/room data, visual screenshots, File Vault status, local Git project discovery, Agent Task Queue, Agent Tool Queue, Task Board, Model Gateway, and Permission Hall receipts. Reports are written under ignored `workspace\vertical-slice-proofs` and do not invoke agents, scan whole disks, stage Git, commit, push, or contact GitHub.

Godot Testing Arena caches the proof list and exposes `Next Proof` / `Open Proof` controls for bounded Markdown previews. Preview reads are constrained to `workspace\vertical-slice-proofs` and return `not-found` for unknown IDs.

## Bug Clinic

Bug Clinic is the first diagnostic triage room. It reads:

- failed backend jobs from the in-memory job queue
- failed Terminal Control logs under `workspace\terminal-logs`
- diagnostic memory events under `workspace\memory-events`
- known issues documented in project memory, such as the unavailable Claude review connector
- visual verification status from Testing Arena
- bug-report drafts under `workspace\bug-reports`

The backend exposes `GET /api/bug-clinic/overview` and `POST /api/bug-clinic/reports`. Draft creation writes only a Markdown bug report and records a local memory event. It does not edit code, apply fixes, run commands, stop services, or revert files.

## Project Management Hall

Project Management Hall is the first portfolio room. It aggregates:

- bounded local Git project discovery from Code Workshop
- research boards from Research Hall
- task status and dispatch draft counts from Task Board
- local Git dock counts from GitHub Harbor
- project brief drafts under `workspace\project-briefs`

The backend exposes `GET /api/project-management/overview` and `POST /api/project-management/briefs`. Draft creation writes only a Markdown project brief and records a local memory event. It does not modify repositories, issue trackers, research experiments, or external agents.

## Download Station

Download Station is the first download/import intake room. It reads shallow, bounded samples from allowlisted roots:

- the current user's Downloads folder
- `D:\Downloads`
- `D:\Game_develop\Downloads`
- project `art`
- `workspace\asset-intake`
- intake drafts under `workspace\download-intake`

The backend exposes `GET /api/download-station/overview`, `GET /api/download-station/triage`, and `POST /api/download-station/intake-drafts`. Triage reads a bounded recent-file sample from one allowlisted download root, classifies file types, flags executables/archives/large/transient files for manual review, records suggested intake routes, and SHA-256 hashes small files. Draft creation writes only a Markdown intake plan and records a local memory event. It does not move, delete, open, extract, execute, install, upload, or fetch files.

## Asset Resource Gallery

Asset Resource Gallery is the first visual asset curation room. It reads bounded samples from allowlisted art and evidence roots:

- `godot\assets`
- `art`
- `frontend\public\assets`
- project visual docs under `docs`
- `screenshots`
- asset notes under `workspace\asset-notes`

The backend exposes `GET /api/asset-gallery/overview`, `GET /api/asset-gallery/inspect`, and `POST /api/asset-gallery/notes`. Asset inspection resolves only allowlisted files, hashes files up to 10 MB, and parses lightweight image dimensions for PNG/GIF/JPEG/WebP without opening or importing the asset. Note creation writes only a Markdown curation note and records a local memory event. It does not edit, move, delete, copy, import, optimize, generate, or publish assets.

## Local Office Center

Local Office Center is the first local-office workflow room. It reads bounded samples from allowlisted office roots:

- `D:\Company`
- project docs under `docs`
- writing drafts under `workspace\drafts`
- project briefs under `workspace\project-briefs`
- office notes under `workspace\office-notes`

The backend exposes `GET /api/local-office-center/overview` and `POST /api/local-office-center/notes`. Note creation writes only a Markdown office note and records a local memory event. It does not edit, move, delete, open, email, upload, sync, or otherwise mutate company/source files.

## Schedule And Plan Center

Schedule and Plan Center is the first local planning and timebox room. It reads lightweight planning signals from:

- `PLAN.md`
- `MEMORY.md`
- `workspace\tasks\tasks.json`
- selected shared-memory status/policy files
- office notes under `workspace\office-notes`
- schedule drafts under `workspace\schedules`

The backend exposes `GET /api/schedule-plan-center/overview` and `POST /api/schedule-plan-center/drafts`. Draft creation writes only a Markdown schedule plan and records a local memory event. It does not edit calendars, install schedulers, start jobs, stop services, change trackers, or notify external systems.

## Learning Training Grounds

Learning Training Grounds is the first local learning and practice room. It reads bounded training signals from:

- `D:\agent-resources\SKILL-INDEX.md`
- project architecture and visual baseline docs
- selected shared-memory workflow/rule files
- schedule drafts under `workspace\schedules`
- learning plans under `workspace\learning-plans`

The backend exposes `GET /api/learning-training-grounds/overview` and `POST /api/learning-training-grounds/plans`. Plan creation writes only a Markdown learning plan and records a local memory event. It does not install skills, run commands, invoke agents, edit shared memory, enroll external courses, or change schedules.

## Language Learning Area

Language Learning Area is the first multilingual practice room. It reads bounded language/UI signals from:

- `README.md`
- `docs\VISUAL_BASELINE.md`
- `godot\README.md`
- `MEMORY.md`
- practice notes under `workspace\language-practice`
- learning plans under `workspace\learning-plans`

The backend exposes `GET /api/language-learning-area/overview` and `POST /api/language-learning-area/practice`. Practice creation writes only a Markdown phrase-practice note and records a local memory event. It does not call translators, external APIs, agents, calendars, or edit source UI/documentation.

## Backup Station

Backup Station is the first backup and restore-planning room. It reads shallow, bounded snapshots from backup sources and targets:

- AI Town project root
- shared agent memory
- Godot registry data
- project docs
- project-local workspace
- `D:\Backups`
- `workspace\backups`
- `D:\devtools\backups`
- backup plan drafts under `workspace\backup-plans`

The backend exposes `GET /api/backup-station/overview`, `GET /api/backup-station/integrity`, and `POST /api/backup-station/plans`. The integrity endpoint reads a bounded sample from an allowlisted source, records sizes and modified times, and SHA-256 hashes small files for restore-check planning. Draft creation writes only a Markdown backup plan and records a local memory event. It does not copy, delete, compress, restore, schedule, upload, or prune files.

## Long-Term Goal Tower

Long-Term Goal Tower is the first long-horizon planning room. It reads:

- open and completed checklist items from `PLAN.md`
- project memory from `MEMORY.md`
- selected shared-memory facts, preferences, and decisions
- Task Board status counts
- Project Management Hall portfolio counts
- goal drafts under `workspace\goals`

The backend exposes `GET /api/goal-tower/overview` and `POST /api/goal-tower/goals`. Draft creation writes only a Markdown goal plan and records a local memory event. It does not modify trackers, repositories, experiments, schedules, or agent runners.

## Inspiration Collection Station

Inspiration Collection Station is the first idea-inbox room. It reads:

- `PLAN.md`
- `MEMORY.md`
- `docs\VISUAL_BASELINE.md`
- `docs\ARCHITECTURE_GODOT_REBUILD.md`
- selected shared-memory project status
- nearby project-local drafts
- inspiration notes under `workspace\inspiration`

The backend exposes `GET /api/inspiration-station/overview` and `POST /api/inspiration-station/notes`. Note creation writes only a Markdown inspiration note and records a local memory event. It does not edit source docs, shared memory, trackers, repositories, assets, or agent runners.

## Temporary Draft Box

Temporary Draft Box is the first scratch-note and draft-triage room. It reads project-local draft shelves:

- `workspace\drafts`
- `workspace\tasks`
- `workspace\agent-dispatch`
- `workspace\automation-drafts`
- `workspace\settings-drafts`
- `workspace\test-plans`
- `workspace\bug-reports`
- `workspace\project-briefs`
- `workspace\download-intake`
- `workspace\asset-notes`
- `workspace\office-notes`
- `workspace\schedules`
- `workspace\learning-plans`
- `workspace\language-practice`
- `workspace\backup-plans`
- `workspace\goals`
- `workspace\inspiration`
- `workspace\temp-drafts`

The backend exposes `GET /api/temporary-draft-box/overview` and `POST /api/temporary-draft-box/drafts`. Draft creation writes only a Markdown scratch note and records a local memory event. It does not promote, delete, route, overwrite, or send drafts to agents or external tools.

## Agent Hub

The Agent Hub maps real local agent infrastructure without controlling processes:

- detects agent launcher candidates under `D:\devtools`
- reports whether `D:\devtools\agent-hub` and its `state` directory exist
- lists mailbox files when they exist
- lists recent devtools logs
- creates project-local dispatch drafts under `workspace\agent-dispatch`
- creates project-local Agent Chat logs under `workspace\agent-chats`
- queues selected Agent Chat tool suggestions through the safe Agent Tool Registry
- opens safe Agent Task Queue result details through `GET /api/agent-tasks/{task_id}`
- pauses/resumes selected safe Agent Task Queue items through the backend queue endpoints
- polls selected safe Agent Task Queue event streams through `GET /api/agent-tasks/{task_id}/events?since=...`
- opens selected safe Agent Tool invocation details through `GET /api/agent-tools/invocations/{invocation_id}`
- polls selected safe Agent Tool invocation event streams through `GET /api/agent-tools/invocations/{invocation_id}/events?since=...`

Dispatch drafts are safe staging files only. The game does not send them to an external runner, start an agent, stop a process, or kill a terminal.

## Code Workshop

The Code Workshop is the first real software-development building. It uses bounded, lazy Git discovery over D-drive work roots:

- `D:\Game_develop`
- `D:\Research`
- `D:\devtools`
- the current AI Town repo

The index is intentionally lightweight. It discovers a small sample of Git repos and defers expensive status/log/README previews until the user opens one repo detail. The Godot room exposes `Code Projects` and `Repo Detail`.

Repo detail now uses the first backend job path: Godot queues a read-only inspection job, then polls job status/result. This keeps expensive Git inspection out of the Godot main thread and establishes the pattern for future model calls, indexing, PDF parsing, terminal work, and agent execution.

Code Workshop can also create a project-local code task draft through `POST /api/projects/{project_id}/code-task-draft`. This writes under ignored `workspace\tasks`, updates `workspace\tasks\tasks.json`, and records a local memory event under `workspace\memory-events`. The richer draft includes priority, acceptance criteria, Git status, recent commits, candidate file previews, suggested verification commands, safety gates, and an agent handoff prompt. It does not modify the selected repository, execute shell commands, install dependencies, stage/commit/push Git state, or invoke an external agent runner.

Code Workshop now creates project-local context packs for selected repositories through `POST /api/projects/{project_id}/context-pack`. A pack is written under ignored `workspace\code-contexts` and includes bounded Git status, recent commits, important-file previews, detected verification command suggestions, and a development brief for a target agent. The selected repository is read only; suggested commands are not executed by this endpoint.

Code Workshop also has a safe `Code Agent` path. Godot submits a `code-review-brief` task to `/api/agent-tasks/submit` with the selected `project_id`. The backend builds a read-only development analysis payload with Git status, recent commits, sampled important-file previews, detected verification commands, risks, recommended next steps, JSON task logs, and a local memory event. This is still an internal safe task adapter; it does not start Claude/Codex/OpenCode runners and does not write to the selected repository.

Code Workshop also has a safe `Explain Code` path. Godot submits a `code-explain-brief` task to `/api/agent-tasks/submit` with the selected `project_id`. The backend builds an onboarding-oriented explanation with README/PLAN excerpts, entry points, key files, concepts, candidate verification commands, and recommended reading path. It writes only the Agent Task JSON log and memory event; the selected repository remains read-only and no commands are executed.

Code Workshop can now run selected verification commands through `POST /api/projects/{project_id}/verification-jobs`. Commands come only from `detect_project_commands()` allowlist entries, execute through argv arrays, require `RUN_PROJECT_CHECK`, and run inside the backend job queue. Results are stored as JSON under `workspace\project-verification-logs`, include bounded stdout/stderr, return code, duration, timeout state, and memory event, and are visible in Godot through `Run Check` / `Check Job`. The endpoint does not accept arbitrary command strings, does not stage/commit/push Git state, and does not edit files.

## GitHub Harbor

GitHub Harbor is the first GitHub/release workflow building. It currently reads local Git metadata only:

- repository remotes
- branches
- recent commits
- tags
- release-note draft text

It does not push, create tags, create releases, or open PRs. Those future actions must use confirm-required safety gates.

`GET /api/github-harbor/repos/{project_id}/github` adds a read-only GitHub CLI snapshot. It runs only fixed `gh` read commands (`auth status`, `repo view`, `issue list`, and `release list`) from the selected repo, returns repository metadata, issue/release summaries, auth availability, and bounded errors, and degrades cleanly when `gh`, auth, network, or remote metadata is unavailable. The client cannot pass arbitrary `gh` arguments, and the endpoint does not stage, commit, tag, push, create PRs, create issues, create releases, or mutate remotes.

## Terminal Control

Terminal Control is the first controlled command-execution room. It does not expose an arbitrary shell. Instead it:

- lists a small allowlist of project-local commands
- previews the selected command before execution
- requires the confirmation phrase `RUN_LOCAL_COMMAND`
- queues execution through the backend job system
- writes command logs under ignored `workspace\terminal-logs`
- records a project-local memory event under ignored `workspace\memory-events`
- renders recent log details in Godot through `Next Log` and `Open Log`

The first allowlisted commands are bounded checks for the AI Town project: Git status, backend Python compile, and a root file listing. This establishes the safety pattern for future terminal workflows.

`GET /api/terminal/commands` returns the command catalog plus recent sanitized logs. Godot caches these logs so the player can inspect bounded stdout/stderr, return code, duration, working directory, safety class, and log path without opening arbitrary files or running a raw shell.

## System Monitor

System Monitor is the first observability room. It is read-only and summarizes:

- FastAPI bridge status
- AgentMemory service health
- shared memory, knowledge base, research root, and devtools path availability
- building and agent registry counts
- backend job queue counts and recent jobs
- workspace folders for drafts, task ledger, dispatch drafts, memory events, terminal logs, and backend job logs
- recent Terminal Control logs
- unified local event timeline from `GET /api/system/events`

The Godot room exposes `System Status`, `Job Queue`, `Cancel Job`, `Open Job Log`, `Job Events`, and `Event Log` controls. `GET /api/system/jobs` reports queue status plus cancelability, rollback notes, persistent log paths, and recent `workspace\backend-job-logs` summaries. `GET /api/jobs/{job_id}/events` returns cursor-based backend job lifecycle events for polling UIs, falling back to persistent job logs after in-memory jobs are pruned; Godot's `Job Events` button keeps a cursor for the selected job and can poll repeatedly without reloading the whole job body. `GET /api/system/job-logs` returns a read-only index of those lifecycle logs, and `GET /api/system/job-logs/{log_id}` opens one bounded detail view with status, events, error text, rollback note, and result preview. `POST /api/jobs/{job_id}/cancel` cancels queued jobs before execution and records cancellation intent for running/finished jobs; it does not kill processes or undo filesystem changes automatically. The event timeline aggregates existing memory events, local task cards, backend jobs, terminal logs, Agent Task Queue items, and Agent Tool Queue invocations. It is read-only and does not run commands, invoke agents, rescan roots, or mutate files.

## Model Market / API Gateway

Model Market is the first API-key and model-channel visibility room. It reads profile definitions from:

- `godot\data\model_profiles.json`

The backend exposes provider readiness without secrets:

- provider/profile name
- role and model list
- key environment variable name
- configured/missing boolean
- base URL environment variable name
- resolved base URL
- secret policy
- active dialogue provider/status
- OpenAI-compatible chat route through `POST /api/model-gateway/chat`
- no-secret setup drafts under `workspace\model-config-drafts`
- no-secret profile test reports under `workspace\model-test-results`
- encrypted local key vault metadata under `workspace\model-key-vault`

Raw API keys are never returned to Godot or written into room text. The initial profiles cover DeepSeek, OpenAI-compatible, Anthropic-compatible, Gemini-compatible, and a local OpenAI-style proxy.

NPC dialogue now calls the Model Gateway instead of a hard-coded DeepSeek URL. The gateway selects a configured OpenAI-compatible profile when available, falls back to safe missing-key/status responses when unavailable, and returns only profile/status metadata to Godot. Anthropic and Gemini profiles remain visible for readiness/configuration but are not yet live chat adapters unless routed through an OpenAI-compatible proxy.

`POST /api/model-gateway/config-drafts` creates a no-secret setup draft with placeholder environment variables, review checklist, restart notes, and smoke-test instructions. It writes only under ignored `workspace\model-config-drafts`; it does not edit `.env`, process environment variables, shell profiles, registries, or launchers. The committed `.env.example` is a placeholder template only and must never contain real keys.

`POST /api/model-gateway/profile-tests` records bounded readiness reports for one model profile. The default Godot `Test Profile` flow uses a dry-run route check, writes only under ignored `workspace\model-test-results`, records a project-local memory event, and does not contact external providers. Optional live probes are constrained to a short self-test prompt and still return/write only sanitized route metadata plus bounded response/error previews.

`GET /api/model-gateway/key-vault` returns local encrypted key vault metadata only: profile id, label, key env name, fingerprint, length, timestamp, source, and encryption class. `POST /api/model-gateway/key-vault` can save a key only after `SAVE_API_KEY` confirmation; on Windows it encrypts with DPAPI current-user scope and writes `workspace\model-key-vault\key-vault.json`. The backend can use this vault as a fallback when the process environment variable is missing, but no endpoint returns the raw key and Permission Hall records only fingerprint-based receipts.

## Active Rebuild Architecture

`docs\PROJECT_AUDIT_2026-05-29.md` records what is active, what is legacy, and what must be replaced. `docs\ARCHITECTURE_GODOT_REBUILD.md` supersedes the older Phaser-first architecture for current implementation. `docs\VISUAL_BASELINE.md` records the long-term warm storybook / magic-tech visual standard.

## Registry Data

The first dynamic registry files are:

- `godot\data\buildings.json`
- `godot\data\agents.json`
- `godot\data\model_profiles.json`

Godot loads these files at startup and falls back to internal defaults if they are missing or malformed. The backend exposes the same files through config endpoints so future tools and plugin installers can inspect the active world model.

## Local Save

Godot stores lightweight player progression at `user://agent_town_save.json`:

- accepted quest IDs
- completed quest IDs
- per-quest step completion
- earned badges and their collections
- Room Mastery XP/levels/visit counts/action counts
- NPC quest-chain stage progress and completion flags
- collection codex ownership/progress state derived from badges, companions, daily routes, room mastery, and NPC chains
- last current room marker

Room Mastery is local-only player progression. Entering a building adds room XP; completing safe workbench scans or confirmed local drafts adds more XP. Level milestones award `Room Mastery` badges in the same local Badge Case. This layer does not call backend write endpoints, mutate project files, launch agents, or contact external services.

## Write Safety Model

The first write-capable action is deliberately project-local and two-phase:

1. `prepare-work-note` returns a Markdown preview and target path under `workspace/drafts/`.
2. `confirm-save-work-note` writes only when the request includes `confirmation: SAVE_LOCAL_DRAFT`.

No external project folders are modified by this action.

## Quest Chain Model

Current quests use a simple four-step loop:

1. `accept`
2. `enter_room`
3. `review_shelves`
4. `scan`

Godot only awards the quest badge after every step is marked complete.
