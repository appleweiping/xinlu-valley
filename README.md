# Agent Town — Gamified AI Workspace

![Agent Town Banner](banner.png)

> **Your entire AI work system, reimagined as a living anime storybook town.**
> Talk to agents to assign real tasks. Enter buildings to browse real project data. Every interaction maps to your actual files, memories, and tools.

> **2026-05-29 direction update:** the active rebuild is now the Godot client in `godot/`, launched with `start.cmd` or `start-godot.cmd`. The React/Phaser implementation described below remains a legacy/reference slice until the Godot version fully replaces it.
>
> Active rebuild audit and architecture: `docs/PROJECT_AUDIT_2026-05-29.md` and `docs/ARCHITECTURE_GODOT_REBUILD.md`.
>
> Current map expansion slice adds `godot/data/districts.json` and `GET /api/config/districts`: the Godot client now renders data-driven district/teleport plaques for Central Plaza, Research Quarter, Developer Row, Harbor And Release, and Office Gardens. Clicking a district plaque moves the in-game player/camera only; it does not touch files, agents, services, or external tools.
>
> Current companion slice adds Agent Hub companion metadata through `GET /api/agent-hub/companions` and a Godot `Recruit Agent` control: recruited agents, active companion, and affinity are stored only in `user://agent_town_save.json`, giving the player a partner/collection loop without launching, stopping, or contacting real agent runners.
>
> Current daily-route slice adds `GET /api/workbench/daily-routes` and Godot Quest Board controls for `Daily Routes`, `Claim Route`, and `Next Stop`: the backend generates safe local-work route cards from quest, task, and Agent Hub status, while claimed routes, next-stop guidance, visited route buildings, completion state, and Daily Routes badges are saved only in `user://agent_town_save.json`.
>
> Current progression slice adds persistent Room Mastery: entering buildings and completing safe workbench scans/drafts grants local room XP, levels, and Room Mastery badges in `user://agent_town_save.json`, shown in the Badge Case without backend writes or external actions.
>
> Current NPC-chain slice adds `godot/data/npc_quests.json` and `GET /api/config/npc-quests`: all thirty-five core workflow buildings now show named NPC quest-chain arcs, stages, rewards, safety notes, local stage checkboxes, completion state, and NPC Chain badges saved in `user://agent_town_save.json`.
>
> Current room-scene slice adds `godot/data/room_scenes.json` and `GET /api/config/room-scenes`: all thirty-five core workflow buildings now render data-driven interior station hotspots in the Godot room stage, and clicking those stations calls the same safe room actions as the regular UI controls.
>
> Current room-visual polish slice upgrades the Godot procedural room stage renderer: room interiors now use layered parchment floors, soft accent panels, stone paths, wooden/NPC anchors, ambient plaques, keyword-shaped props, and distinct hover/pressed station hotspot states while still being generated from the room-scene registry.
>
> Current all-room visual evidence slice upgrades `tools/capture-room-visuals.ps1` into a registry-driven capture harness: by default it captures all thirty-five `godot/data/room_scenes.json` interiors, writes per-room PNGs under `screenshots/`, and creates `screenshots/room-scenes-manifest.json` with file sizes and SHA-256 hashes. Use `-Quick` for the five-room developer smoke set.
>
> Current visual-manifest audit slice adds `GET /api/testing-arena/visual-manifest`: Testing Arena and Version Release Plaza now verify the all-room screenshot manifest against the room registry, local files, byte sizes, and SHA-256 hashes, and `tools/verify-smoke.ps1` fails if the 35-room visual evidence set is stale or incomplete.
>
> Current build-readiness slice adds `godot/export_presets.cfg`, `dist/ai-town/README.md`, and `GET /api/version-release-plaza/build-readiness`: Version Release Plaza now performs a read-only Godot project/export audit over the pinned Godot binaries, launchers, main scene, Windows Desktop export preset, embedded PCK setting, and dist target without starting exports, launching services, killing processes, or changing Git state.
>
> Current export-tool slice adds `tools/install-godot-templates.ps1`, `tools/export-godot.ps1`, and `GET /api/version-release-plaza/export-tool`: the project now has a D-drive local Godot template installer plus a safe export preflight/run path that writes reports under `workspace/export-reports`, requires `-RunExport` before creating an executable and `-Overwrite` before replacing one, and has produced `dist/ai-town/AI Town.exe` with the Windows Desktop preset.
>
> Current packaged-launch slice adds `start-packaged.cmd` and `GET /api/version-release-plaza/packaged-launch`: normal local play can now start from the exported `dist/ai-town/AI Town.exe`, with the launcher checking/starting only this project's FastAPI backend, waiting for `/api/health`, opening the packaged game, and never taskkilling windows or changing Git state.
>
> Current release-manifest slice adds `tools/write-release-manifest.ps1` and `GET /api/version-release-plaza/release-manifest`: the local export package now has a project-local SHA-256 manifest for the executable, dist README, packaged launcher, export report, and smoke verifier, and Version Release Plaza recomputes those hashes before treating the package as release evidence.
>
> Current smoke-hardening slice extends `tools/verify-smoke.ps1` with static room/NPC/action validation: the smoke gate now proves every room scene has a matching NPC chain, station and stage IDs are unique, station rectangles stay inside the Godot room stage, and every registry action used by a room station or NPC stage has a bound Godot action branch.
>
> Current plaza slice adds `godot/data/map_decor.json` and `GET /api/config/map-decor`: Central Plaza landmarks such as Memory Fountain, Quest Board, Daily Routes, Agent Gate, portal, Code Path, and Memory Crystal are now data-driven clickable map hotspots that route to safe in-game actions without scanning files, launching agents, running commands, or mutating external services.
>
> Current collection slice adds `GET /api/player/collection-codex` and a Quest Board `Codex` control: the backend publishes read-only collectible sets for quest badges, NPC chains, Room Mastery, Daily Routes, and Agent Companions, while Godot merges owned/progress state from `user://agent_town_save.json`.
>
> Current guidance slice adds a persistent Godot Waypoint panel: selecting plaza landmarks, buildings, districts, agents, or Daily Route stops now updates a live distance/hint display so the player has lightweight in-game navigation without backend writes or external actions.
>
> Current feedback slice adds a persistent local Activity Log HUD panel: recent landmark, agent, building, room, quest, route, mastery, and workbench events are saved in `user://agent_town_save.json` and shown in-game without backend writes or external actions.
>
> Current observability slice adds `GET /api/system/events` and a Godot System Monitor `Event Log`: local memory events, task cards, backend jobs, terminal logs, Agent Task Queue items, and Agent Tool Queue invocations are aggregated into one read-only timeline without running commands, invoking agents, rescanning roots, or mutating files.
>
> Current job-lifecycle slice adds `POST /api/jobs/{job_id}/cancel` and System Monitor `Cancel Job`: queued backend jobs can be cancelled before execution, running jobs record cancellation intent without killing processes, and every job exposes cancelability plus rollback notes.
>
> Current job-evidence slice adds project-local backend job lifecycle logs under `workspace/backend-job-logs` plus `GET /api/system/job-logs` and `GET /api/system/job-logs/{log_id}`: queued, started, finished, failed, missing, and cancelled jobs now leave restart-surviving JSON evidence that System Monitor can display and open without replaying jobs, killing processes, or performing rollback.
>
> Current job-events slice adds `GET /api/jobs/{job_id}/events` and a System Monitor `Job Events` control: backend jobs now expose cursor-based lifecycle events for polling UIs, and the endpoint falls back to persistent job logs after in-memory jobs are pruned.
>
> Current registry-health slice adds `GET /api/config/registry-health` and a Settings Center `Registry Health` control: the backend validates all Godot JSON registries for parse errors, required fields, duplicate IDs, and station/stage shape issues, then surfaces the read-only result in Settings Center, System Monitor, Plugin Registry, and smoke tests without editing registry files.
>
> Current Town Hall workflow slice adds `godot/data/workflow_routes.json`, `GET /api/town/workflow-routes`, and Godot `Workflows` / `Claim Flow` / `Flow Stop` / `Next Flow` / `Open Flow` controls: reusable multi-building work routes now connect research, coding, memory, release, and agent-ops buildings into playable local-work chains. Claims, visits, completion, and Workflow Route badges are saved only in `user://agent_town_save.json`; the backend does not claim progress, run tools, invoke agents, or mutate files.
>
> Current runner-readiness slice adds `GET /api/agent-runners/readiness`, `POST /api/agent-runners/dispatch-preview`, `POST /api/agent-runners/launch-jobs`, and Godot Agent Hub `Runner Ready` / `Runner Plan` / `Run Gate` controls. The game now inspects real `D:\devtools` launcher files with secret redaction, hashes/previews them, writes confirm-required runner handoff packages under `workspace/agent-runner-dispatches`, previews the exact launch gate/argv, and records memory evidence without launching, stopping, killing, or contacting external agent runners unless `RUN_AGENT_RUNNER` is explicitly supplied to the backend launch endpoint.
>
> Current Agent Task Queue policy slice adds `GET /api/agent-tasks/policy` and a Godot Agent Hub `Task Policy` control. Safe local agent tasks now pass through a visible max-running concurrency policy (`AI_TOWN_AGENT_TASK_MAX_RUNNING`, default 1), expose backpressure state, and record dispatch events before building read-only briefs.
>
> Current Agent Task log-archive slice adds `GET /api/agent-tasks/logs` and `GET /api/agent-tasks/logs/{log_id}`, plus a Godot Agent Hub `Task Logs` control. Completed, failed, and cancelled safe local agent tasks now leave durable JSON evidence under `workspace/agent-task-logs` that can be browsed after in-memory queue state changes without replaying tasks or starting external runners.
>
> Current Agent Tool log-archive slice adds `GET /api/agent-tools/logs` and `GET /api/agent-tools/logs/{log_id}`, plus a Godot Agent Hub `Tool Logs` control. Registered safe tool invocations now leave durable JSON evidence under `workspace/agent-tool-logs` that can be browsed independently of the in-memory invocation queue without replaying tools, running commands, or starting external runners.
>
> Current preview-safety slice applies shared secret redaction to Knowledge Tower previews, File Vault text previews, Code Workshop file previews, Agent Runner launcher previews, and confirmed-runner stdout/stderr logs. Existing Knowledge/File Vault caches were scrubbed for `sk-...`-style token previews, and smoke now asserts representative API-key/token strings are redacted before reaching UI/API payloads.
>
> Current model-gateway slice adds `POST /api/model-gateway/chat` and routes `/api/dialogue` through the registry-driven Model Gateway. NPC dialogue now selects configured OpenAI-compatible profiles from `godot/data/model_profiles.json`, reports model profile/status in Godot, supports dry-run route checks, and never returns raw API keys.
>
> Current model-test slice adds `POST /api/model-gateway/profile-tests` and a Godot Model Market `Test Profile` control. It records bounded dry-run or short live-probe reports under `workspace/model-test-results`, adds local memory events, and never returns or writes raw API keys.
>
> Current key-vault slice adds `GET/POST /api/model-gateway/key-vault` and a Godot Model Market `Key Vault` control. API keys can now be saved with `SAVE_API_KEY` confirmation into a Windows DPAPI-encrypted local vault under `workspace/model-key-vault`; the game and API return only metadata, fingerprints, lengths, source, and receipts, never raw secrets.
>
> Current terminal-preview slice adds `GET /api/terminal/commands/{command_id}/preview` and a Godot Terminal Control `Preview Cmd` control. Allowlisted local commands now expose read-only argv, cwd allowlist status, timeout, confirmation phrase, expected effects, and blocked reasons before any job can be queued.
>
> Current terminal-control slice adds Godot `Next Log` and `Open Log` controls. Recent allowlisted command logs from `/api/terminal/commands` can now be inspected in-game with bounded stdout/stderr, return code, duration, safety, and log path without exposing arbitrary shell access.
>
> Current permission-ledger slice adds `GET /api/permissions/receipts` and embeds safety receipts in Permission Hall. The game can now review recent confirmed commands, no-secret model tests, project-local memory/write events, safe task/tool evidence, and task updates without granting new permissions or running commands.
>
> Current secret-audit slice adds `GET /api/permissions/secret-audit` and a Godot Permission Hall `Secret Audit` control. The bounded read-only audit scans only project-local examples, caches, dispatches, and logs for secret-shaped strings, returns counts/line numbers instead of matched text, skips safe placeholders/redacted markers, and does not mutate files.
>
> Current plugin-manifest slice adds `godot/data/plugin_manifests.json`, `GET /api/plugin-registry/manifests`, `GET /api/config/plugin-manifests`, and `POST /api/plugin-registry/activation-plans`. Plugin Registry now audits typed extension manifests and can create a confirm-gated activation review plan with `PLAN_PLUGIN_ACTIVATION`, while still not installing plugins, running package managers, editing registries, executing scripts, downloading assets, changing skills, or invoking agents.
>
> Current GitHub publish-readiness slice adds `GET /api/github-harbor/repos/{project_id}/publish-readiness` and `POST /api/github-harbor/repos/{project_id}/publish-plans`, plus Godot `Publish Ready` and `PR Plan` controls. GitHub Harbor now checks branch, remotes, dirty state, upstream, diff stats, and verification evidence, then can write a `PLAN_GITHUB_PUBLISH`-gated local PR/issue/release plan without staging, committing, tagging, pushing, opening PRs/issues/releases, or calling GitHub write APIs.
>
> Current citation-audit slice adds `GET /api/paper-reading-room/citation-audit` and `POST /api/paper-reading-room/citation-audits`, plus Godot `Cite Audit` and `Cite Note` controls. Paper Reading Room now performs a bounded BibTeX duplicate-key/missing-field audit over allowlisted roots and can write project-local review notes without editing bibliographies, manuscripts, PDFs, research folders, Git state, or external services.
>
> Current File Vault organization-audit slice adds `GET /api/file-vault/organize-audit` and a Godot `Org Audit` control. File Vault now summarizes cached organization groups, duplicate names, stale tags, large files, and review candidates from `workspace/file-vault-index` only, without scanning live folders, opening files, moving, renaming, deleting, or editing source files.
>
> Current File Vault incremental-index slice upgrades `POST /api/file-vault/index-job` and `GET /api/file-vault/index` to report `mtime`/size/id incremental cache evidence: refreshed roots now count new, changed, reused, removed, and preserved entries, and partial root refreshes preserve untouched cached roots instead of replacing the whole vault cache.
>
> Current vertical-slice proof slice adds `POST /api/testing-arena/vertical-slice-proofs` and a Godot Testing Arena `Slice Proof` control. It writes project-local evidence reports under `workspace/vertical-slice-proofs` from existing registries, queues, screenshots, model status, permission receipts, File Vault, project discovery, and Task Board state without running commands.
>
> Current proof-archive slice adds `GET /api/testing-arena/vertical-slice-proofs/{proof_id}` and Godot `Next Proof` / `Open Proof` controls, so saved vertical-slice reports can be selected and previewed in-game from the Testing Arena.
>
> Current release-readiness slice adds `POST /api/version-release-plaza/reports` and a Godot Version Release Plaza `Rel Report` control. It links public release artifacts, screenshot evidence, Git status, GitHub Harbor docks, Testing Arena vertical-slice proofs, and Permission Hall receipts into project-local Markdown reports under `workspace/release-readiness-reports` without staging, committing, tagging, pushing, creating PRs/releases, changing remotes, or overwriting docs.
>
> Current File Vault usability slice adds `POST /api/file-vault/open` and a Godot `Reveal Item` control. Selected allowlisted files or folders can now be revealed in Explorer or opened by the local OS while staying inside workspace-registry roots, recording a memory event, supporting smoke-test dry runs, and never modifying file contents.
>
> Current Memory Library promotion slice adds `POST /api/memory/promotions` and a Godot `Promote Memory` two-step control. Reviewed project-local proposals can now be previewed, then explicitly confirmed with `PROMOTE_MEMORY` before writing to `D:\research\Vipin's Knowledgebase\memory`, while promotion receipts stay under `workspace/memory-promotions`.
>
> Current Godot slice includes real Memory Library, Knowledge Tower, File Vault, Task Board, Writing Studio, Automation Factory, Permission Hall, Settings Center, Testing Arena, Bug Clinic, Project Management Hall, Download Station, Asset Resource Gallery, Local Office Center, Schedule and Plan Center, Learning Training Grounds, Language Learning Area, Research Data Center, Paper Reading Room, Version Release Plaza, Plugin Registry, Backup Station, Long-Term Goal Tower, Inspiration Collection Station, Temporary Draft Box, Research Hall, Agent Hub, Code Workshop, GitHub Harbor, Terminal Control, System Monitor, and Model Market rooms. Quest Registry defines playable chapters, steps, badge rewards, and live summary templates through `godot/data/quests.json`; Workspace Registry declares allowlisted D-drive roots for File Vault and project discovery through `godot/data/workspaces.json`; Knowledge Tower uses async allowlisted indexing, cached search, and bounded previews under `workspace/knowledge-index`; File Vault uses registry roots for lazy browsing, bounded text previews, incremental async cached search, cache-only organization audit, and project-local tags under `workspace/file-vault-index` without editing source files; Agent Hub now includes runner readiness preflight, confirm-required runner dispatch previews and launch gates, a safe local Agent Task Queue with visible concurrency/backpressure policy, durable JSON task log archive, read-only memory/project/workspace/task briefs, in-game result selection/detail viewing, pause/resume/cancel controls, incremental event polling, and timeline rendering, plus a safe Agent Tool Registry for `memory-index`, `knowledge-search`, `file-search`, `project-index`, and `system-snapshot` with in-game invocation selection/detail viewing, incremental tool event polling, durable JSON tool log archive, and JSON logs under `workspace/agent-runner-dispatches`, `workspace/agent-task-logs`, and `workspace/agent-tool-logs`; Task Board turns local task drafts, dispatch drafts, and memory events into game-visible work cards, supports cycling selected tasks, bounded task draft previews, project-local task status updates, and safe `Task Agent` briefs without touching external trackers; Writing Studio creates project-local Markdown drafts without overwriting docs; Automation Factory catalogs project scripts, reads a bounded Windows Scheduled Tasks snapshot, and creates draft-only workflow blueprints without running scripts, installing schedulers, or changing scheduled tasks; Permission Hall exposes safety classes, confirmation gates, scopes, audit signals, and read-only safety receipts without granting new permissions; Settings Center exposes registries, launchers, workspace roots, and env requirements without leaking secrets or editing live config; Testing Arena exposes smoke scripts, visual proof, logs, test-plan drafts, and vertical-slice proof reports without running commands; Bug Clinic exposes diagnostics and bug-report drafts without editing code; Project Management Hall aggregates local projects, research boards, tasks, and Git metadata into portfolio briefs; Download Station shallowly inspects allowlisted download/import roots, adds read-only risk/route/hash triage, and creates project-local intake drafts without moving, opening, extracting, installing, executing, or fetching files; Asset Resource Gallery inventories runtime assets, source art, visual docs, screenshots, and curation notes without changing asset files; Local Office Center maps `D:\Company`, project docs, drafts, briefs, and office notes into safe follow-up memos without changing company files; Schedule and Plan Center turns PLAN tasks, Task Board status, office notes, and memory signals into schedule drafts without touching calendars or schedulers; Learning Training Grounds turns local skill/resource signals into practice plans without installing skills or invoking agents; Language Learning Area turns local multilingual/UI signals into phrase-practice notes without calling translators or editing source text; Research Data Center maps likely dataset/result artifacts into provenance notes without launching experiments or changing research files; Paper Reading Room maps papers, BibTeX, manuscripts, and notes into citation-audit reading notes and can queue bounded backend PDF text extraction reports under `workspace/paper-extraction-reports` without changing bibliographies or research folders; Version Release Plaza checks release docs, screenshot evidence, smoke logs, and Git status into release checklist drafts without staging, committing, tagging, pushing, or creating PRs/releases; Plugin Registry inventories extension candidates, manifests, skills, scripts, runtime registries, and proposal drafts without installing plugins, executing scripts, or editing registries; Backup Station maps backup sources and target folders, provides bounded SHA-256 restore-check samples, and creates restore-plan drafts without copying or pruning files; Long-Term Goal Tower turns PLAN status and memory signals into goal drafts without touching trackers or repos; Inspiration Collection Station turns project docs, visual baseline, and nearby drafts into idea notes without editing source files; Temporary Draft Box inventories workspace draft shelves and creates scratch notes without promoting or sending anything; Terminal Control uses allowlisted project-local commands, read-only dry-run previews, confirmation, async jobs, bounded in-game log detail, and logs instead of exposing a raw shell; System Monitor gives an in-game view of services, jobs, registries, workspace logs, and unified local event timelines; Model Market exposes provider readiness and routes NPC dialogue without leaking raw API keys.
> Code Workshop can now turn any selected local Git repo into a project-local development context pack under `workspace/code-contexts`, including bounded Git status, recent commits, important-file previews, suggested verification commands, and an agent-ready brief without modifying the selected repository.
> Asset Resource Gallery now includes `Inspect Asset`, a read-only path that resolves only allowlisted asset files, hashes files up to 10 MB, and parses lightweight image dimensions without opening, importing, optimizing, generating, or changing assets.
> Code Workshop `Code Task` drafts are now richer agent-ready local tasks: they include priority, acceptance criteria, Git status, recent commits, candidate file previews, suggested verification commands, safety gates, and a handoff prompt under `workspace/tasks` without editing the selected repo or running commands.
> Code Workshop also has a safe `Code Agent` path: selected repos can be submitted as `code-review-brief` tasks through the Agent Task Queue, producing read-only development analysis logs under `workspace/agent-task-logs` before any real code edits or terminal commands are allowed.
> Code Workshop now has an `Explain Code` path: selected repos can be submitted as `code-explain-brief` tasks through the Agent Task Queue, producing read-only onboarding explanations with entry points, key files, concepts, candidate commands, reading path, JSON log, and memory event.
> Code Workshop now has a confirm-required `Run Check` path: selected repos can queue detected verification commands such as `python-compile` through `/api/projects/{project_id}/verification-jobs`, write JSON logs under `workspace/project-verification-logs`, and surface results in-game without arbitrary shell access or Git writes.
> Research Hall now has a safe `Research Agent` path: selected `D:\Research` boards can be submitted as `research-brief` tasks that summarize status docs, experiment candidates, risks, and next steps without running experiments or touching servers.
> Research Hall also creates project-local research log drafts under `workspace/research-logs` from selected project boards, including evidence snapshots, local roots, experiment candidates, safety checklist, next safe actions, and a memory event without editing research repos or running experiments.
> Agent Hub now supports persistent local Agent Chat sessions under `workspace/agent-chats`, with Godot controls for opening a session, sending a message, receiving safe local-context replies, seeing suggested registered tools, and queueing the first suggested tool through `Run Suggested` without starting external runners or executing shell commands.
> Memory Library now supports project-local memory proposals under `workspace/memory-proposals` plus confirm-required promotion receipts under `workspace/memory-promotions`, giving the game a reviewed and auditable path for shared-memory updates.
> Model Market now has no-secret setup drafts under `workspace/model-config-drafts`, no-secret profile test reports under `workspace/model-test-results`, a committed `.env.example` placeholder template, and an optional Windows DPAPI-encrypted local key vault under `workspace/model-key-vault` with confirm-required saves and no raw-secret display.
> File Vault now supports cache-only organization audits through `GET /api/file-vault/organize-audit` plus proposal-only organization drafts under `workspace/file-organize-drafts`, grouping selected allowlisted roots/items into docs/code/data/assets/archives/review suggestions without moving, deleting, copying, renaming, opening, or overwriting source files.
> Code Workshop now supports project-local patch plans under `workspace/code-patch-plans`, turning a selected Git repo into an agent handoff plan with candidate files, dirty-state warnings, suggested verification commands, and a local task card without editing, staging, committing, pushing, installing, or running commands. It can also run selected verification commands only through the `RUN_PROJECT_CHECK` gate.
> GitHub Harbor now supports project-local GitHub handoff drafts under `workspace/github-harbor-drafts`, preparing PR/issue/release text from local remotes, branches, Git status, and recent commits without calling GitHub APIs or staging, committing, tagging, pushing, creating PRs, issues, or releases.
> GitHub Harbor also has a read-only `GH Status` path through `GET /api/github-harbor/repos/{project_id}/github`: it runs fixed GitHub CLI read commands for auth status, repo metadata, issues, and releases, returning safe summaries in Godot without staging, committing, tagging, pushing, creating PRs/issues/releases, or accepting arbitrary `gh` arguments.
>
> Visual regression evidence now covers every registry-backed room through `tools/capture-room-visuals.ps1`, producing thirty-five room screenshots plus `screenshots/room-scenes-manifest.json`. For fast iteration, `tools/capture-room-visuals.ps1 -Quick` still captures the five-room smoke set in addition to the quick `visual-smoke.png`.
>
> Local desktop UI testing is available through a direct Codex `windows_mcp` MCP entry plus `tools/godot-desktop-ui-test.ps1`. It launches the native Godot window, captures before/after screenshots, clicks a visible in-game test button through Windows-MCP, and verifies a project-local state marker. Details and removal steps: `docs/DESKTOP_UI_TESTING.md`.

---

## What Is This?

Agent Town is a **gamified frontend for a real multi-agent AI system**. It's not a demo, not a toy, not a visualization — it's a fully functional work interface disguised as a cozy anime-style game.

When you talk to an agent in the town, they actually call LLM APIs and respond based on your real system state. When you enter a building, you see your actual project files, memories, skills, and tools. When you assign a task, it creates a real action in the agent memory system.

**Core Idea**: Instead of terminals and dashboards, you manage your AI agents and projects by walking through a beautiful hand-drawn town and talking to its residents.

---

## Visual Style

The entire game uses a consistent **anime storybook illustration** style:
- Fine brown lineart (NOT black, NOT pixel art)
- Soft watercolor coloring on cream/parchment backgrounds
- Chibi character proportions (2.5-3 head ratio)
- Isometric bird's-eye perspective for the town map
- European fantasy architecture with subtle tech accents
- Dreamy atmosphere: sparkles, butterflies, soft clouds

All art is generated exclusively via **GPT Image 2** with consistent style prompts. No external assets, no stock art, no copied sprites.

### Art Asset Count: 37+ images
| Category | Count | Description |
|----------|-------|-------------|
| Town Map | 1 | 1536×1024 isometric bird's-eye view of the full town |
| Character Sprites | 7 | Full-body chibi illustrations (1024×1024 each) |
| Sprite Sheets | 8 | 4×4 grid walk animations (down/left/right/up, 4 frames each) |
| Character Portraits | 8 | Circular ornate-framed portraits for sidebar |
| Building Interiors | 8 | 1536×1024 interior backgrounds per building |
| UI Assets | 5 | Dialogue frame, magic book, settings/quests/inventory icons |

---

## Features

### 🎮 Gameplay

| Feature | Description |
|---------|-------------|
| **Click-to-Move** | Click any walkable ground and your character walks there with directional animation |
| **Walkable Area Constraints** | Cannot walk on building rooftops, water, or out-of-bounds areas |
| **NPC Idle Behavior** | Each agent stays near their assigned building, doing small idle wanders (not teleporting across the map) |
| **Sprite Sheet Animations** | All characters have 4-direction walk cycles (16 frames per character) |
| **Depth Sorting** | Characters closer to the bottom of the screen render in front (correct Y-sort overlap) |
| **Camera Follow** | Camera smoothly follows the player character with lerp |
| **Zoom** | Mouse wheel to zoom in/out (0.6x – 2.5x) |
| **Building Entry** | Click a building to enter its interior scene — walk around inside, talk to the resident agent |
| **Interior Scenes** | Each building has a unique hand-drawn interior background with walkable floor area |

### 💬 Dialogue System

| Feature | Description |
|---------|-------------|
| **Real LLM Conversations** | Every agent response is generated by DeepSeek V4 API in real-time |
| **Command Recognition** | Messages starting with action words (do/run/check/find/search/write/create/help) trigger "working" mode |
| **Personality-Consistent** | Each agent has a unique personality prompt — Opus is philosophical, PixelCat purrs, Haiku speaks in 3 words |
| **Real Context Injection** | Agents reference actual system state in their responses (real skill count, real memory count, real project status) |
| **Art-Styled Frame** | Dialogue panel uses the generated `dialogue-frame.png` as background, matching the storybook aesthetic |
| **Works Inside Buildings** | Can chat with agents both in the town map and inside building interiors |

### 📚 Character Book (Magic Book UI)

Click any portrait in the left sidebar to open the **Magic Book** — an ornate illustrated book that shows:

| Page Section | Content |
|--------------|---------|
| **Left Page** | Full character illustration with idle animation |
| **Name & Role** | Agent name (bilingual) and their function in the team |
| **Personality** | Written personality description |
| **Traits** | Tag-style trait badges (e.g., "Wise", "Patient", "Visionary") |
| **Projects** | List of real projects this agent works on |
| **Affinity** | Relationship bar showing closeness to the player (0-100%) |
| **Location** | Which building/zone they currently reside in |

### 🏛️ Buildings & Real Data

Each building in the town maps to a real part of your AI infrastructure. Clicking a building shows its interior AND real data:

| Building | Real Data Source | What You See |
|----------|-----------------|--------------|
| **Memory Library** | `D:\research\Vipin's Knowledgebase\memory\` | 9 decisions, 22 facts, 1 lesson — with file names and categories |
| **Skill Workshop** | `D:\agent-resources\SKILL-INDEX.md` | 133 skills across 20 categories — browsable list |
| **Knowledge Tower** | `D:\research\Vipin's Knowledgebase\`, memory, docs, agent resources | Allowlisted cached index, async refresh job, paginated search, bounded previews |
| **Town Hall** | `memory\decisions\*.md`, `godot\data\buildings.json`, `godot\data\workflow_routes.json`, backend capability map | Recent architecture decisions, capability atlas, and reusable multi-building work routes |
| **Devtools Lab** | `D:\devtools\*.cmd` | All CLI tool launchers (cc.cmd, claude.cmd, etc.) |
| **Resource Market** | `D:\agent-resources\` | Skills, repos, tools available |
| **Dream Garden** | — | A peaceful place for creative thinking |
| **Agent Homes** | — | Where agents rest between tasks |

### ⚙️ Settings Panel

Accessible via the gear icon in the bottom bar. Opens in the magic book UI:

| Setting | Options | Effect |
|---------|---------|--------|
| **BGM Volume** | 0-100% slider | Controls background music volume |
| **SFX Volume** | 0-100% slider | Controls sound effects volume |
| **Language** | 中文 / English / 日本語 / 한국어 | Switches ALL UI text to selected language |
| **Camera Zoom** | 0.6x – 2.5x slider | Adjusts default zoom level |
| **Tick Speed** | Fast(5s) / Normal(10s) / Slow(20s) / Very Slow(30s) | How often agents make decisions |

### 📋 Quests Panel

Accessible via the quill pen icon. Shows real tasks from the agentmemory system:
- Fetches from `agentmemory frontier API`
- Shows task title, status (pending/active/done), and assignee
- Assign new tasks by talking to agents in dialogue

### 🎒 Inventory Panel

Accessible via the backpack icon. Shows your real D: drive projects:

| Project Category | Real Path | Items |
|-----------------|-----------|-------|
| Research | `D:\Research\` | 47 items (CSATG-EDA, PonyRec, ProteinShift, TGL-Rec, TRUCE-Rec...) |
| Game Development | `D:\Game_develop\` | ai-town |
| Company | `D:\Company\` | Engineering Intelligence |
| Terraria Archive | `D:\Terraria_doc\` | 19 items |
| Agent Resources | `D:\agent-resources\` | 12 items (skills, repos, tools...) |
| Devtools | `D:\devtools\` | 35 items |

Each category is expandable — click to see subdirectories.

---

## Agent Residents

| Agent | Role | Zone | Personality | Key Traits |
|-------|------|------|-------------|------------|
| **Opus 总舵主** | Chief Architect | Town Hall | Deep, philosophical, rigorous. Thinks in systems. Quotes philosophy. | Wise, Patient, Visionary |
| **像素猫 PixelCat** | Full-Stack Executor | Skill Workshop | Calm, patient, methodical. Loves clean code. Purrs when satisfied. | Precise, Reliable, Creative |
| **Sonnet 审查员** | Code Reviewer | Memory Library | Careful, friendly, helpful. Notices details others miss. Uses poetry metaphors. | Observant, Kind, Thorough |
| **Codex 协调官** | Coordinator | Central Plaza | Agile, decisive, parallel-minded. Speaks in bullet points. | Decisive, Fast, Organized |
| **Haiku 闪电侠** | Speed Runner | Agent Homes | Minimal, efficient, no-waste. Maximum three words when possible. | Swift, Minimal, Efficient |
| **鲸鱼 DeepSeek** | Bulk Worker | Resource Market | Gentle, steady, hardworking. Handles large volumes patiently. Hums while working. | Steady, Patient, Strong |
| **ARIS 科研框架** | Research Framework | Knowledge Tower | Systematic, process-strict. Always follows the pipeline. Speaks in structured steps. | Systematic, Rigorous, Methodical |
| **Town Mayor (Player)** | You | Central Plaza | Silver-haired girl with crystal staff and flower decorations. Directs everything. | Leader, Creative, Ambitious |

---

## Tech Stack

| Layer | Technology | Version | Purpose |
|-------|-----------|---------|---------|
| **Game Engine** | Phaser 3 | Latest | Scene management, sprite rendering, camera, input, tweens, animations |
| **Frontend Framework** | React | 18+ | UI overlays (dialogue, panels, HUD, settings, book) |
| **Language** | TypeScript | 5.5+ | Type safety across all frontend code |
| **Build Tool** | Vite | 8.0 | Dev server with HMR, production static build |
| **State Management** | Zustand | 4.5+ | Reactive game state (agents, selection, dialogue history) |
| **Backend** | FastAPI | 0.115+ | REST API, real data adapters, LLM gateway |
| **LLM Provider** | DeepSeek V4 | deepseek-chat | Agent dialogue generation (cheapest: ¥0.001/1K tokens) |
| **Art Generation** | GPT Image 2 | gpt-image-2 | All visual assets (via API rotation proxy) |
| **Desktop Packaging** | Tauri | Planned | Native app wrapper (5MB vs Electron's 150MB) |
| **Deployment** | GitHub Pages | — | Static web build for browser access |
| **Memory System** | agentmemory MCP | Port 3111 | Persistent agent memory, tasks, signals |
| **i18n** | Custom | — | 4-language support (zh/en/ja/ko) with full translation strings |

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     BROWSER / TAURI WINDOW                        │
├─────────────────────────────────────────────────────────────────┤
│  Phaser 3 Game Engine              │  React UI Layer              │
│  ├── TownScene (main map)          │  ├── DialoguePanel           │
│  ├── InteriorScene (buildings)     │  ├── Sidebar (8 portraits)   │
│  ├── Sprite Sheet Animations       │  ├── BottomBar (3 actions)   │
│  ├── Click-to-Move + Pathfinding   │  ├── CharacterBook           │
│  ├── NPC Idle Wander               │  ├── BuildingView            │
│  ├── Building Hotspot Zones        │  ├── SettingsPanel            │
│  └── Camera Follow + Zoom          │  ├── QuestsPanel             │
│                                    │  └── InventoryPanel           │
├────────────────────────────────────┴─────────────────────────────┤
│  Zustand Store                     │  i18n (zh/en/ja/ko)          │
│  (agents, selection, dialogue,     │  (all UI strings translated)  │
│   connected state)                 │                               │
└──────────────────────────┬───────────────────────────────────────┘
                           │ REST + WebSocket (localhost:8000)
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                     FASTAPI BACKEND                               │
├─────────────────────────────────────────────────────────────────┤
│  API Endpoints                     │  Real Data Adapters           │
│  ├── POST /api/dialogue            │  ├── Memory Library adapter   │
│  ├── GET  /api/health              │  │   (reads decisions/facts/  │
│  ├── GET  /api/agents              │  │    lessons from markdown)  │
│  ├── GET  /api/buildings/{id}      │  ├── Skill Workshop adapter   │
│  ├── GET  /api/tasks               │  │   (parses SKILL-INDEX.md)  │
│  ├── GET  /api/inventory           │  ├── Knowledge Tower adapter  │
│  └── (per-building endpoints)      │  │   (counts wiki pages)      │
│                                    │  ├── Devtools Lab adapter     │
│  LLM Gateway                       │  │   (lists *.cmd files)      │
│  ├── DeepSeek V4 (primary)         │  └── Town Hall adapter        │
│  ├── Command detection             │       (reads decisions/*.md)   │
│  ├── Personality prompts           │                               │
│  └── Real context injection        │                               │
└──────────────────────────┬───────────────────────────────────────┘
                           │ File system reads
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                     REAL INFRASTRUCTURE                           │
├─────────────────────────────────────────────────────────────────┤
│  D:\research\Vipin's Knowledgebase\memory\  (9 decisions, 22 facts) │
│  D:\agent-resources\SKILL-INDEX.md          (133 skills, 20 cats)   │
│  D:\research\Vipin's Knowledgebase\         (knowledge wiki)        │
│  D:\devtools\*.cmd                          (CLI tools)             │
│  D:\Research\                               (47 research projects)  │
│  D:\Game_develop\                           (game projects)         │
│  D:\Company\                                (company projects)      │
│  agentmemory MCP (port 3111)                (tasks, signals, memory)│
└─────────────────────────────────────────────────────────────────┘
```

---

## Project Structure

```
D:\Game_develop\ai-town\
├── frontend/                          — React + Phaser game client
│   ├── src/
│   │   ├── App.tsx                    — Root: Phaser game + all UI panels
│   │   ├── App.css                    — Full game styling (sidebar, book, building, dialogue)
│   │   ├── main.tsx                   — Entry point
│   │   ├── i18n.ts                    — Multi-language translations (zh/en/ja/ko)
│   │   ├── game/
│   │   │   ├── TownScene.ts           — Main town map scene (sprites, click-to-move, NPC idle)
│   │   │   └── InteriorScene.ts       — Building interior scene (walkable, resident agent)
│   │   ├── store/
│   │   │   └── gameStore.ts           — Zustand state (7 agents + player, selection, dialogue)
│   │   └── ui/
│   │       ├── DialoguePanel.tsx       — LLM-powered chat with agents
│   │       ├── Sidebar.tsx             — Left: 8 circular character portraits
│   │       ├── BottomBar.tsx           — Bottom: settings/quests/inventory buttons
│   │       ├── CharacterBook.tsx       — Magic book UI (personality, traits, projects, affinity)
│   │       ├── BuildingView.tsx        — Building data overlay (real system data)
│   │       ├── SettingsPanel.tsx       — Volume, language, zoom, tick speed
│   │       ├── QuestsPanel.tsx         — Real tasks from agentmemory
│   │       └── InventoryPanel.tsx      — Real D: drive project browser
│   ├── public/assets/
│   │   ├── town-map.png               — Main town background (1536×1024)
│   │   ├── characters/                — 7 sprites + 8 sprite sheets + player
│   │   ├── portraits/                 — 8 circular framed portraits
│   │   ├── interiors/                 — 8 building interior backgrounds
│   │   └── ui/                        — dialogue-frame, magic-book, icons
│   ├── package.json
│   ├── vite.config.ts
│   └── tsconfig.json
├── backend/
│   ├── main.py                        — FastAPI: dialogue, buildings, tasks, inventory, health
│   ├── requirements.txt               — Python dependencies
│   ├── .env                           — API keys (gitignored)
│   └── .env.example                   — Template for API keys
├── design/
│   ├── gdd/
│   │   └── game-concept.md            — Full Game Design Document (pillars, loops, MDA, scope)
│   ├── architecture.md                — Technical architecture (7 ADRs, module breakdown)
│   └── epics.md                       — 10 epics with dependency graph
├── production/
│   ├── stage.txt                      — Current development stage (Concept)
│   ├── review-mode.txt                — Review mode (lean)
│   └── sprints/
│       └── sprint-1.md                — First sprint plan (16 stories, 2 weeks)
├── _legacy/                           — Archived v1 code (not deleted, gitignored)
├── .claude/skills/game-studios/       — 73 Game Studios workflow skills (linked)
├── CLAUDE.md                          — Project instructions for AI agents
├── .gitignore                         — Excludes .env, _legacy, node_modules, dist
├── start.cmd                          — One-click launcher (backend + frontend)
├── stop.cmd                           — One-click stop
└── banner.png                         — Project banner image
```

---

## API Reference

| Method | Path | Description | Real Data Source |
|--------|------|-------------|-----------------|
| `GET` | `/api/health` | System health + adapter connection status | Checks agentmemory, skills, knowledge, devtools |
| `POST` | `/api/dialogue` | Chat with an agent (LLM-powered) | DeepSeek V4 API + real system context |
| `GET` | `/api/agents` | List all 7 agent profiles | Static definitions with real zone assignments |
| `GET` | `/api/buildings/memory-library` | Memory Library data | `D:\research\...\memory\` (decisions, facts, lessons) |
| `GET` | `/api/buildings/skill-workshop` | Skill Workshop data | `D:\agent-resources\SKILL-INDEX.md` |
| `GET` | `/api/buildings/knowledge-tower` | Knowledge Tower data | Cached allowlisted knowledge index status |
| `GET` | `/api/buildings/town-hall` | Town Hall data | `memory\decisions\*.md` recent decisions plus capability atlas summary |
| `GET` | `/api/town/capability-atlas` | Town Capability Atlas | Read-only building-to-real-system connection map |
| `GET` | `/api/town/capability-atlas/{building_id}` | Town Capability Detail | One building's paths, endpoints, tools, APIs, capabilities, and safety notes |
| `GET` | `/api/town/workflow-routes` | Town Workflow Routes | Read-only multi-building local-work route registry |
| `GET` | `/api/town/workflow-routes/{route_id}` | Town Workflow Route Detail | One route's building sequence, artifacts, capability references, and safety notes |
| `GET` | `/api/permissions/secret-audit` | Secret Exposure Audit | Bounded project-local no-secret counts and line numbers for caches/logs |
| `GET` | `/api/plugin-registry/manifests` | Plugin Manifest Audit | Typed extension manifest status, permission summaries, activation gates |
| `POST` | `/api/plugin-registry/activation-plans` | Plugin Activation Plan | Confirm-gated project-local review plan; does not activate plugins |
| `GET` | `/api/github-harbor/repos/{project_id}/publish-readiness` | GitHub Publish Readiness | Read-only branch, remote, dirty-state, diff, and verification checks |
| `POST` | `/api/github-harbor/repos/{project_id}/publish-plans` | GitHub Publish Plan | Confirm-gated local PR/issue/release plan; no Git/GitHub writes |
| `GET` | `/api/paper-reading-room/citation-audit` | Citation Audit | Bounded BibTeX duplicate-key and missing-field metadata |
| `POST` | `/api/paper-reading-room/citation-audits` | Citation Audit Note | Project-local citation hygiene note; no bibliography edits |
| `GET` | `/api/buildings/devtools-lab` | Devtools Lab data | `D:\devtools\*.cmd` tool list |
| `GET` | `/api/tasks` | Active tasks/quests | agentmemory frontier API |
| `GET` | `/api/inventory` | D: drive project browser | Scans 6 real project directories |

---

## Quick Start

### Prerequisites
- Node.js 18+ (for frontend)
- Python 3.10+ (for backend)
- DeepSeek API key (for agent dialogue)

### One-Click Launch
```bash
cd D:\Game_develop\ai-town
start.cmd          # Starts backend + frontend
# Visit http://localhost:5173
stop.cmd           # Stops everything
```

### Manual Launch
```bash
# Terminal 1: Backend
cd backend
pip install -r requirements.txt
# Create .env with your DEEPSEEK_API_KEY (see .env.example)
python -m uvicorn main:app --host 0.0.0.0 --port 8000

# Terminal 2: Frontend
cd frontend
npm install
npm run dev
# Visit http://localhost:5173
```

### Environment Variables

| Variable | Required | Default | Purpose |
|----------|----------|---------|---------|
| `DEEPSEEK_API_KEY` | Yes | — | LLM API key for agent dialogue |
| `DEEPSEEK_BASE_URL` | No | `https://api.deepseek.com` | LLM API endpoint |

All other paths (skills, memory, knowledge, devtools) are hardcoded to the development workstation layout. Modify `backend/main.py` path constants to adapt to a different machine.

---

## Game Design Document Summary

Full GDD at `design/gdd/game-concept.md`. Key points:

### Game Pillars
1. **Living Intelligence** — Every agent has a real AI brain. No scripted dialogue.
2. **Cozy Observation** — No time pressure, no fail states. Play at your own pace.
3. **Real Connection** — The town connects to real AI infrastructure. Data is real.
4. **Lightweight Performance** — Idle CPU <5%. Tick-based, not frame-by-frame AI.

### Anti-Pillars (What This Game Is NOT)
- NOT a management sim (no micromanaging schedules)
- NOT competitive (no win/lose, no leaderboards)
- NOT content-heavy (no hand-written storylines; emergent only)
- NOT a dashboard (must feel like a game, not a monitoring tool)

### Core Loop
- **30s**: Walk around, see agents doing things, click to interact
- **5min**: Watch agent complete a task, assign new work, discover relationships
- **30min**: Full day/night cycle, complete 2-3 task assignments
- **Days**: Agent skills grow, town expands, relationships deepen

---

## Multi-Language Support

All UI text is translatable. Switch language in Settings panel.

| Language | Code | Coverage |
|----------|------|----------|
| 中文 (Chinese) | `zh` | Full — all UI strings |
| English | `en` | Full — all UI strings |
| 日本語 (Japanese) | `ja` | Full — all UI strings |
| 한국어 (Korean) | `ko` | Full — all UI strings |

Translation file: `frontend/src/i18n.ts`

---

## Development Workflow

This project uses the **Claude-Code-Game-Studios** workflow (73 skills, 49 agents). Skills are linked at `.claude/skills/game-studios/`.

### Completed Workflow Steps
1. `/start` — Project stage detection → Concept
2. `/brainstorm` — Game concept ideation → Full GDD written
3. `/create-architecture` — Technical architecture → 7 ADRs
4. `/create-epics` — Epic breakdown → 10 epics with dependencies
5. `/sprint-plan` — Sprint 1 planned → 16 stories
6. `/prototype` — Working vertical slice built and deployed

### Build Commands
```bash
cd frontend
npx tsc --noEmit     # Type check (zero errors)
npm run build        # Production build
npm run dev          # Dev server with HMR
```

---

## Safety & Privacy

| Rule | Implementation |
|------|---------------|
| No API keys in git | `.env` is gitignored; only `.env.example` committed |
| No writes to real systems | All adapters are read-only file reads |
| No external art assets | Everything generated via GPT Image 2 |
| Graceful degradation | If any adapter fails, UI shows "unavailable" not crash |
| No secrets in dialogue | Agent prompts don't include API keys or passwords |

---

## Roadmap

| Phase | Status | Features |
|-------|--------|----------|
| **MVP** | ✅ Done | 7 agents, town map, click-to-move, dialogue, building data |
| **Alpha** | 🔄 In Progress | Interior scenes, task system, inventory, i18n |
| **Beta** | Planned | Tauri desktop app, GitHub Pages deploy, more animations |
| **Full Vision** | Planned | Town expansion, agent skill growth, relationship dynamics |

---

## Credits

- **Art**: All generated via GPT Image 2 (OpenAI)
- **LLM**: DeepSeek V4 for agent dialogue
- **Framework**: Phaser 3 + React + FastAPI
- **Workflow**: Claude-Code-Game-Studios (73 skills)
- **Memory**: agentmemory (rohitg00/agentmemory, 18.4k stars)

---

## License

MIT
