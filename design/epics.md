# Epics — Pixel Agent Town v2

*Created: 2026-05-27*

---

## Epic 1: Core Engine & Rendering
**Priority**: P0 (MVP blocker)
**Systems**: Phaser 3 scene, tilemap, camera, sprite system, animation state machine
**Goal**: A beautiful pixel town renders smoothly at 60fps with tile-based map, buildings, and animated agent sprites.
**Stories**:
- Set up Phaser 3 + React + Vite project from scratch
- Create tilemap system (40×30 grid, terrain layers)
- Implement camera (pan, zoom, follow player)
- Build agent sprite system (animated, directional movement)
- Add building sprites with zone boundaries
- Implement day/night lighting cycle
- Add particle effects (ambient: leaves, fireflies)

---

## Epic 2: Agent AI Decision Engine
**Priority**: P0 (MVP blocker)
**Systems**: LLM gateway, decision engine, batch processing, caching
**Goal**: Agents make intelligent decisions every tick via LLM, with batching and caching for performance.
**Stories**:
- Build LLM gateway (DeepSeek primary, Haiku fallback)
- Implement response cache (LRU, 5-min TTL, context-hash key)
- Build batch decision system (collect all agents → one API call)
- Create agent decision prompt template (personality + context + options → action)
- Implement zone-based activation (only nearby agents think)
- Add lazy tick scaling (10s active → 30s idle → 60s AFK)
- Build decision-to-action mapper (LLM output → game state change)

---

## Epic 3: Agent Behavior & Movement
**Priority**: P0 (MVP blocker)
**Systems**: State machine, pathfinding, activity system
**Goal**: Agents move smoothly between locations, perform activities, and transition between states naturally.
**Stories**:
- Implement A* pathfinding on tile grid
- Build agent state machine (idle, walking, working, talking, resting)
- Create activity system (per-zone activities: coding, reviewing, researching, etc.)
- Add smooth movement interpolation (tile-to-tile over time)
- Implement agent scheduling (daily routines as soft preferences, LLM can override)
- Add idle animations per activity type

---

## Epic 4: Dialogue System
**Priority**: P0 (MVP blocker)
**Systems**: Dialogue generation, conversation history, UI panels
**Goal**: Players can have real conversations with agents; agents talk to each other with visible speech bubbles.
**Stories**:
- Build dialogue generation endpoint (agent context → LLM → response)
- Implement conversation history (per agent-pair, last 10 exchanges)
- Create DialoguePanel React component (chat-style UI)
- Add speech bubble system (agent-to-agent, visible in game world)
- Implement dialogue triggers (proximity, events, player click)
- Add personality-consistent response formatting

---

## Epic 5: Task System
**Priority**: P1 (Alpha)
**Systems**: Task creation, assignment, execution, reporting
**Goal**: Player can assign tasks to agents; agents collaborate to complete them and report results.
**Stories**:
- Design task data model (type, assignee, status, progress, result)
- Build task assignment UI (TaskPanel component)
- Implement task execution logic (agent works on task during work activity)
- Add task collaboration (multiple agents on one task)
- Create task completion reporting (agent announces result)
- Connect to real agentmemory actions (optional: real task tracking)

---

## Epic 6: Relationship System
**Priority**: P1 (Alpha)
**Systems**: Relationship graph, dynamics, emergent events
**Goal**: Agents form relationships (friendship, rivalry, mentorship) that evolve over time and affect behavior.
**Stories**:
- Build relationship graph (agent pairs, relationship type, strength)
- Implement relationship dynamics (interactions affect strength)
- Add relationship-aware dialogue (friends talk differently than strangers)
- Create emergent relationship events (new friendship, conflict, reconciliation)
- Display relationship indicators in UI (hearts, tension marks)

---

## Epic 7: Real Data Adapters
**Priority**: P1 (Alpha)
**Systems**: agentmemory, skills, knowledge, devtools adapters
**Goal**: Town reflects real AI infrastructure state — real memories, real skills, real knowledge.
**Stories**:
- Implement agentmemory adapter (read memories, lessons, observations)
- Build skills adapter (parse SKILL-INDEX.md, show in Workshop)
- Create knowledge adapter (count wiki pages, show in Library)
- Add devtools adapter (list tools, show status)
- Display real data in zone-specific UI panels
- Graceful fallback to mock data when adapters unavailable

---

## Epic 8: World & Zones
**Priority**: P1 (Alpha)
**Systems**: Zone management, building interiors, zone-specific activities
**Goal**: 9+ distinct zones with unique activities, visuals, and purposes.
**Stories**:
- Design zone layout (expanded from v1, larger map)
- Implement zone transitions (walk between zones)
- Create zone-specific activity sets
- Add zone ambient effects (sounds, particles, lighting)
- Build zone inspection UI (click building → see zone details)
- Generate zone art assets (GPT Image 2)

---

## Epic 9: UI & HUD
**Priority**: P1 (Alpha)
**Systems**: HUD, panels, notifications, settings
**Goal**: Clean, pixel-art-styled UI that provides information without breaking immersion.
**Stories**:
- Design pixel-art HUD (time, zone, agent count, connection status)
- Build notification system (events, task completions, relationship changes)
- Create settings panel (tick speed, audio, display options)
- Implement minimap (optional, shows agent positions)
- Add event log panel (scrollable recent events)

---

## Epic 10: Packaging & Deployment
**Priority**: P2 (Beta)
**Systems**: Tauri build, GitHub Pages deploy, CI/CD
**Goal**: Game runs as both a web app (GitHub Pages) and a native desktop app (Tauri).
**Stories**:
- Set up Tauri project (src-tauri/)
- Configure Vite for static build (GitHub Pages compatible)
- Set up GitHub Actions for auto-deploy on push
- Add Tauri build scripts (Windows installer)
- Create start.cmd / stop.cmd launchers

---

## Epic Dependencies

```
Epic 1 (Rendering) ──┐
Epic 2 (AI Engine) ──┼──→ Epic 3 (Behavior) ──→ Epic 4 (Dialogue)
                     │                      ──→ Epic 5 (Tasks)
                     │                      ──→ Epic 6 (Relations)
                     └──→ Epic 7 (Adapters)
                     └──→ Epic 8 (Zones)
                     └──→ Epic 9 (UI)
                                            ──→ Epic 10 (Packaging)
```

**MVP (4 weeks)**: Epics 1 + 2 + 3 + 4 (partial)
**Alpha (8 weeks)**: + Epics 5 + 6 + 7 + 8 + 9
**Beta (12 weeks)**: + Epic 10 + polish
