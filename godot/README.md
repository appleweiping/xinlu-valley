# Agent Town Godot Client

This directory is the active Godot rebuild of Agent Town.

## Run

1. Start the existing FastAPI bridge if you want live local data:
   `..\start.cmd`
2. Open this folder in Godot 4.6.3 stable:
   `..\tools\godot\Godot_v4.6.3-stable_win64.exe --path .`

The first slice supports:

- Click-to-move exploration on the existing town map.
- Agent selection and dialogue through `POST /api/dialogue`.
- Building inspection through `GET /api/buildings/{id}`.
- Quest Board with safe registry-backed local work quests from `data\quests.json` and `GET /api/workbench/quests`.
- Daily Routes on the Quest Board: loads safe generated route cards from `GET /api/workbench/daily-routes`, saves claimed routes in `user://agent_town_save.json`, guides the player to the next unvisited route building, tracks visited route buildings, completes routes, and awards local Daily Routes badges.
- Collection Codex on the Quest Board: loads possible collectibles from `GET /api/player/collection-codex`, then merges owned Quest Badges, NPC Chain badges, Room Mastery, Daily Routes, Workflow Routes, and Agent Companions from the local save.
- Multi-step quest progress: accept, enter room, review shelves, safe scan, then badge reward.
- Safe building scans through `POST /api/workbench/action`.
- Two-phase work-note drafts: preview first, then explicit confirmation saves under `workspace/drafts/`.
- Room/workbench panels from `GET /api/workbench/rooms/{building_id}`.
- Procedural room stage inside the panel: wall/floor, NPC, workbench, and shelf-card markers.
- Memory Library console backed by real shared memory shelves and bounded note previews.
- Memory Library proposal flow backed by project-local reviewed memory proposal drafts.
- Memory Library promotion flow: `Promote Memory` previews a reviewed proposal, then `Confirm Promote` writes it to shared memory only after the backend requires `PROMOTE_MEMORY`, with receipts under `workspace\memory-promotions`.
- Knowledge Tower console backed by allowlisted cached indexing, async refresh jobs, paginated search, and bounded document previews.
- Workspace registry loaded from `data\workspaces.json` for allowlisted roots and project discovery.
- District registry loaded from `data\districts.json` for map regions, teleport plaques, district anchors, and connected building lists.
- Map decor registry loaded from `data\map_decor.json` for clickable Central Plaza landmarks such as Memory Fountain, Quest Board, Daily Routes, Agent Gate, portal, Code Path, and Memory Crystal.
- File Vault browser backed by workspace-registry roots, lazy folder listing, bounded text previews, async cached search, and project-local tags.
- File Vault `Reveal Item` flow: selected allowlisted files/folders can be shown in Explorer through the backend without editing file contents.
- File Vault organize plans: creates proposal-only Markdown grouping drafts under `workspace\file-organize-drafts` without moving or modifying source files.
- Research Hall project console backed by real `D:\Research` folders and shared-memory status docs.
- Research Hall `Research Agent` flow: queues selected research boards as safe `research-brief` tasks with ARIS-style next-step logs.
- Research Hall `Research Log` flow: creates selected-board evidence snapshots under `workspace\research-logs` without editing research repos or running experiments.
- Task Board console backed by project-local task ledger, dispatch drafts, memory events, task creation, `Next Task` selection, bounded `Open Task` previews, `Task Agent` read-only briefs, and local `Doing`/`Done` status updates.
- Writing Studio console backed by project docs and local Markdown drafts.
- Automation Factory console backed by local project scripts, read-only Windows scheduler samples, and draft-only workflow blueprints.
- Permission Hall console backed by safety classes, confirmation gates, write scopes, allowlists, audit signals, and read-only safety receipts.
- Settings Center console backed by registries, registry health validation, launchers, environment requirements, and config review drafts.
- Testing Arena console backed by smoke scripts, visual smoke evidence, terminal logs, and test-plan drafts.
- Testing Arena vertical-slice proof reports under `workspace\vertical-slice-proofs`, created from existing evidence without running commands.
- Testing Arena proof archive controls: `Next Proof` / `Open Proof` preview saved vertical-slice reports in-game.
- Bug Clinic console backed by failed jobs/logs, known diagnostics, memory-event signals, and bug-report drafts.
- Project Management Hall console backed by local Git projects, research boards, task status, and project brief drafts.
- Download Station console backed by allowlisted download/import roots, read-only triage risk/routes/hash samples, and intake drafts.
- Asset Resource Gallery console backed by runtime assets, source art, visual docs, screenshots, read-only asset inspection, and curation notes.
- Local Office Center console backed by `D:\Company`, project docs, writing drafts, project briefs, and safe office notes.
- Schedule and Plan Center console backed by PLAN tasks, Task Board status, office notes, memory signals, and schedule drafts.
- Learning Training Grounds console backed by local skill index, practice tracks, workflow signals, and learning plans.
- Language Learning Area console backed by multilingual UI signals, phrase-practice loops, and local practice notes.
- Research Data Center console backed by bounded research data/result candidates, provenance prompts, and local audit notes.
- Paper Reading Room console backed by bounded paper/reference candidates, citation-audit prompts, local reading notes, and async bounded PDF extraction reports through `PDF Extract` / `Check PDF`.
- Version Release Plaza console backed by release-readiness artifacts, screenshot evidence, Git status, checklist drafts, and `Rel Report` readiness reports linked to vertical-slice proof and safety receipt evidence.
- Plugin Registry console backed by extension candidates, runtime registry status, skills, scripts, and local plugin proposal drafts.
- Backup Station console backed by backup source/target snapshots, bounded SHA-256 restore-check samples, and plan drafts.
- Long-Term Goal Tower console backed by PLAN status, shared-memory signals, project portfolio counts, and goal drafts.
- Inspiration Collection Station console backed by project idea signals, visual baseline references, nearby drafts, and inspiration notes.
- Temporary Draft Box console backed by project-local draft shelves and scratch notes.
- Agent Hub console backed by real `D:\devtools` launcher detection, mailbox/log status, safe dispatch drafts, runner readiness preflight, confirm-required runner dispatch previews and launch gates, safe local Agent Task Queue briefs with in-game result detail viewing, pause/resume/cancel controls, incremental `Task Events` polling, timeline events, and registered safe tool invocations with `Next Tool` / `Open Tool` detail viewing plus incremental `Tool Events` polling.
- Agent Chat console backed by persistent project-local JSON sessions, safe local context replies, tool suggestions, `Run Suggested` bridging into Agent Tool Queue, and memory events.
- Agent companion loop: Agent Hub can recruit a selected agent as a local companion, save active companion and affinity in `user://agent_town_save.json`, and show companions in the Badge Case panel without launching real agent runners.
- Registry-backed buildings, agents, workspaces, quests, and NPC quest chains from `data\buildings.json`, `data\agents.json`, `data\workspaces.json`, `data\quests.json`, and `data\npc_quests.json`.
- Town Hall Capability Atlas from `GET /api/town/capability-atlas` and `GET /api/town/capability-atlas/{building_id}`, with in-game `Atlas`, `Next Atlas`, and `Open Atlas` controls for inspecting each building's real paths, endpoints, tools, agents, APIs, capabilities, and safety notes.
- Town Hall Workflow Routes from `data\workflow_routes.json`, `GET /api/town/workflow-routes`, and `GET /api/town/workflow-routes/{route_id}`, with in-game `Workflows`, `Claim Flow`, `Flow Stop`, `Next Flow`, and `Open Flow` controls for guided multi-building local-work chains. Claimed routes, visits, completion state, and Workflow Route badges stay in `user://agent_town_save.json`.
- Registry Health validates the active Godot JSON registries through `GET /api/config/registry-health` and the Settings Center `Registry Health` control without editing the files.
- NPC quest-chain panels: key rooms show named NPC arcs, stage checkboxes, completion state, rewards, and safety notes as local gameplay metadata.
- Room-scene registry from `data\room_scenes.json`: eleven key room interiors render clickable station hotspots that call the same safe room actions as the regular UI controls.
- Plaza landmark hotspots from `data\map_decor.json`: map objects trigger safe hub actions such as quest refresh, daily route load, badge refresh, agent selection, district travel, and building selection.
- Waypoint HUD panel: selected landmarks, districts, buildings, agents, and Daily Route stops show live title, hint, and player distance.
- Activity Log HUD panel: recent local gameplay/work events are saved in `user://agent_town_save.json` and the newest entries stay visible on the map and in rooms.
- Code Workshop console backed by bounded local Git project discovery and repo detail previews.
- First async backend job path: Code Workshop queues read-only repo inspection and polls job status.
- Code Workshop task drafting: creates richer project-local task records with acceptance criteria, candidate file previews, verification hints, safety gates, and memory events without modifying the selected repo.
- Code Workshop context packs: creates selected-repo development briefs under `workspace\code-contexts` with important-file previews and suggested verification commands.
- Code Workshop patch plans: creates selected-repo implementation handoff plans under `workspace\code-patch-plans`, with candidate files, dirty-state warnings, verification candidates, and a local task card.
- Code Workshop `Code Agent` flow: queues selected repos as safe `code-review-brief` tasks and shows the Agent Task Queue result log path.
- Code Workshop `Explain Code` flow: queues selected repos as safe `code-explain-brief` tasks and shows entry points, key files, concepts, reading path, and log evidence in the Agent Task result view.
- Code Workshop `Run Check` flow: previews detected project verification commands, requires `RUN_PROJECT_CHECK`, queues backend jobs, and shows bounded stdout/stderr from `workspace\project-verification-logs`.
- GitHub Harbor console backed by local Git remotes, branches, commits, tags, and release-note draft previews.
- GitHub Harbor handoff drafts: creates local PR/issue/release text under `workspace\github-harbor-drafts` without calling GitHub or writing to Git.
- GitHub Harbor `GH Status`: shows read-only GitHub CLI auth, repo, issue, and release metadata from fixed `gh` commands without writing to GitHub or accepting arbitrary CLI arguments.
- Terminal Control console for allowlisted command jobs with confirmation, project-local logs, and `Next Log` / `Open Log` evidence viewing.
- System Monitor console for service health, job queue, safe job cancellation metadata, rollback notes, cursor-polled backend job events, persistent backend job log index/detail viewing, unified event timeline, registry, workspace, and log status.
- Model Market console for API gateway profiles, active dialogue provider/status, no-secret model key status, registry-driven chat routing, and safe profile test reports.
- Model Market config drafts: creates placeholder-only setup notes under `workspace\model-config-drafts` without saving real keys.
- Model Market profile tests: records dry-run readiness reports under `workspace\model-test-results` and memory events without exposing raw keys.
- Model Market key vault: shows encrypted local key metadata from `workspace\model-key-vault`; backend saves require `SAVE_API_KEY` and never render raw secrets in Godot.
- First storybook visual pass: parchment panels, warm buttons, plaza cues, building sign trim, and softer room-stage colors.
- Persistent Badge Case stored in `user://agent_town_save.json`.
- Room Mastery progression stored in `user://agent_town_save.json`: room visits and safe workbench scans/drafts grant local XP, levels, and mastery badges.
- NPC quest-chain progression stored in `user://agent_town_save.json`: successful safe room actions mark stages complete and award local `NPC Chains` badges.
- Activity Log stored in `user://agent_town_save.json`: landmark, agent, building, room, quest, route, mastery, and workbench feedback survives restart.
- Reserved zones for file management, development tools, agent coordination, memory, knowledge, and research.
- Project-local launch scripts at the repository root:
  - `start.cmd` starts backend + Godot.
  - `start-backend.cmd` starts only the FastAPI bridge.
  - `start-godot.cmd` starts only Godot.

The React/Phaser client remains in `frontend/` as a legacy reference while the Godot rebuild grows.

## Verify

From the repository root:

`powershell -ExecutionPolicy Bypass -File tools\verify-smoke.ps1`

For visual evidence:

`powershell -ExecutionPolicy Bypass -File tools\capture-visual-smoke.ps1`

This writes `screenshots\visual-smoke.png`.

For multi-room visual regression evidence:

`powershell -ExecutionPolicy Bypass -File tools\capture-room-visuals.ps1`

This writes room screenshots for File Vault, Research Hall, Code Workshop, Agent Hub, and Testing Arena under `screenshots\room-*.png`.

For map landmark visual evidence:

`$env:AGENT_TOWN_CAPTURE='1'; $env:AGENT_TOWN_CAPTURE_ROOM='map'; $env:AGENT_TOWN_CAPTURE_OUTPUT='map-plaza.png'; ..\tools\godot\Godot_v4.6.3-stable_win64_console.exe --path . --quit-after 10`

This writes `screenshots\map-plaza.png`.

For local desktop UI automation evidence:

`powershell -ExecutionPolicy Bypass -File tools\godot-desktop-ui-test.ps1`

This launches the native Godot window, captures before/after screenshots, clicks a visible in-game test button through Windows-MCP, and verifies the state marker in `screenshots\desktop-ui-state.json`. See `docs\DESKTOP_UI_TESTING.md` for setup, safety limits, and removal steps.
