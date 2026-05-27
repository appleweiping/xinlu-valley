# Sprint 1 Plan — MVP Foundation

*Sprint Duration: 2 weeks (Week 1-2)*
*Goal: Playable pixel town with 3 AI agents that move, think, and talk*

---

## Sprint Goal

By end of Sprint 1, we have:
- A pixel town rendering at 60fps with tilemap and 3 animated agent sprites
- Agents making LLM-driven decisions every 10 seconds
- Player can click an agent and have a real conversation
- Basic movement and pathfinding working

---

## Stories (ordered by implementation sequence)

### Week 1: Foundation

| # | Story | Epic | Points | Acceptance Criteria |
|---|-------|------|--------|---------------------|
| 1.1 | Set up fresh project (Vite + React + Phaser 3 + TypeScript) | E1 | 2 | `npm run dev` opens browser with Phaser canvas |
| 1.2 | Create tilemap system (40×30 grid, grass/path/water terrain) | E1 | 3 | Visible tile-based map with terrain variety |
| 1.3 | Implement camera (pan with arrow keys, zoom with scroll) | E1 | 2 | Smooth camera movement, zoom 0.5x-3x |
| 1.4 | Build agent sprite system (3 agents, animated walk cycle) | E1 | 3 | 3 distinct agents visible on map, walking animation plays |
| 1.5 | Add 3 building sprites (Town Hall, Workshop, Library) | E1 | 2 | Buildings render at correct tile positions |
| 1.6 | Set up FastAPI backend with WebSocket | E2 | 2 | Backend starts, WS connects, heartbeat works |
| 1.7 | Implement tick loop (10s interval) | E2 | 1 | Console logs tick count every 10s |

### Week 2: Intelligence

| # | Story | Epic | Points | Acceptance Criteria |
|---|-------|------|--------|---------------------|
| 2.1 | Build LLM gateway (DeepSeek API integration) | E2 | 3 | Can send prompt, get response, handle errors |
| 2.2 | Create agent decision prompt template | E2 | 2 | Given context, LLM returns valid action JSON |
| 2.3 | Implement A* pathfinding on tile grid | E3 | 3 | Agent finds path around obstacles |
| 2.4 | Build agent state machine (idle, walking, working) | E3 | 2 | Agent transitions between states smoothly |
| 2.5 | Connect decisions to movement (LLM says "go to Library" → agent walks there) | E3 | 3 | Agent moves to LLM-chosen destination |
| 2.6 | Build dialogue endpoint (click agent → LLM conversation) | E4 | 3 | POST /api/dialogue returns personality-consistent response |
| 2.7 | Create DialoguePanel UI (React overlay) | E4 | 2 | Chat-style panel appears on agent click, shows conversation |
| 2.8 | Add speech bubbles (agent-to-agent, visible in world) | E4 | 2 | Agents occasionally show speech bubbles with short text |

---

## Total Points: 35
## Velocity Estimate: 35 points / 2 weeks (aggressive but achievable with AI assistance)

---

## Technical Setup (Day 0)

Before Sprint 1 stories begin:
- [ ] Clean the existing `frontend/` and `backend/` directories (archive old code to `_legacy/`)
- [ ] Initialize fresh Vite + React + TypeScript project in `frontend/`
- [ ] Initialize fresh FastAPI project in `backend/`
- [ ] Configure Phaser 3 as dependency
- [ ] Set up Zustand for state management
- [ ] Configure WebSocket connection between frontend and backend
- [ ] Set up DeepSeek API key in backend `.env`

---

## Definition of Done (per story)

- [ ] Code compiles without errors
- [ ] Feature works as described in acceptance criteria
- [ ] No performance regression (maintain 60fps frontend, <5% idle CPU backend)
- [ ] Code committed to git with descriptive message

---

## Sprint 1 Risks

| Risk | Mitigation |
|------|-----------|
| DeepSeek API latency >5s | Add loading animation, pre-compute next decision while current executes |
| Phaser 3 + React integration issues | Use proven pattern from v1, keep Phaser in its own div |
| Pathfinding performance on 40×30 grid | Grid is small (1200 nodes), A* will be instant |

---

## Art Assets Needed (generate with GPT Image 2)

| Asset | Size | Style |
|-------|------|-------|
| Terrain tileset (grass, path, water, flowers) | 16×16 per tile | Stardew-warm pixel art |
| 3 agent sprites (Opus, PixelCat, Sonnet) | 32×48, 4-frame walk | Distinct silhouettes, transparent bg |
| 3 building sprites (Town Hall, Workshop, Library) | 64×64 | Cozy pixel buildings with tech accents |
| UI elements (dialogue box, speech bubble) | Various | Pixel-art frame, semi-transparent |
