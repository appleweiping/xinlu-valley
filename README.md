# Pixel AI Town 🏘️

A pixel-art styled AI agent town where multiple AI agents live, work, and interact in a cozy virtual world.

## Overview

Pixel AI Town is a real-time simulation of an AI agent community. Each agent has its own personality, preferred zones, activities, and relationships. The town connects to real agent infrastructure (AgentMemory, Agent Hub, shared knowledge systems) to reflect actual agent states.

## Features

- **8 AI Agent Residents** — Each with unique personality, role, and behavior patterns
- **9 Town Zones** — Town Hall, Memory Library, Skill Workshop, Dream Garden, Devtools Lab, Resource Market, Knowledge Tower, Agent Homes, Central Plaza
- **Real-time Simulation** — Agents move, interact, and change activities every tick
- **Live Data Integration** — Reads from AgentMemory, Agent Hub, and shared knowledge (read-only)
- **Interactive Map** — Click agents for details, click buildings for info, move your character
- **WebSocket Updates** — Smooth real-time state synchronization
- **Pixel Art Style** — Warm pastel palette, cozy aesthetic, all art via GPT Image 2

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Game Engine | Phaser 3 |
| Frontend | React 18 + TypeScript + Vite |
| Styling | Tailwind CSS |
| State | Zustand |
| Backend | FastAPI (Python) |
| Database | SQLite (aiosqlite) |
| Real-time | WebSocket |
| Art | GPT Image 2 |

## Quick Start

```bash
# Install backend dependencies
cd backend
pip install -r requirements.txt

# Install frontend dependencies
cd ../frontend
npm install

# Start everything
cd ..
start.cmd
```

Or manually:
```bash
# Terminal 1: Backend
cd backend
python -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload

# Terminal 2: Frontend
cd frontend
npm run dev
```

Visit http://localhost:5173

### Configuration

The backend reads local infrastructure in read-only mode. Defaults are tuned for this workstation, but every path can be overridden:

| Variable | Purpose |
|----------|---------|
| `PORT` | Backend port, default `8000` |
| `TICK_INTERVAL` | Simulation tick interval in seconds, default `5` |
| `AGENT_HUB_URL` | Agent Hub status API, default `http://127.0.0.1:9800` |
| `SHARED_MEMORY_DIR` | Shared memory directory |
| `SKILL_INDEX_PATH` | Agent resources skill index |
| `KNOWLEDGE_BASE_DIR` | Knowledgebase root |
| `VITE_API_PROXY_TARGET` | Dev-server API proxy target, default `http://localhost:8000` |
| `VITE_WS_PROXY_TARGET` | Dev-server WebSocket proxy target, default `ws://localhost:8000` |
| `VITE_WS_URL` | Optional browser WebSocket URL override |

## Project Structure

```
├── backend/          — FastAPI server + simulation engine
│   ├── main.py       — API endpoints + WebSocket
│   ├── town_engine.py — Tick-based simulation
│   ├── adapters/     — Read-only integrations
│   └── town_data.py  — Agent & building definitions
├── frontend/         — React + Phaser game client
│   ├── src/game/     — Phaser scenes & entities
│   ├── src/ui/       — React overlay panels
│   └── src/store/    — Zustand state management
├── art/              — Art generation pipeline
│   ├── prompts.md    — Style guide
│   └── generate.py   — GPT Image 2 batch generator
├── start.cmd         — One-click launcher
└── stop.cmd          — One-click stop
```

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/health | System health check |
| GET | /api/town/state | Full town state |
| GET | /api/town/agents | All agent profiles |
| GET | /api/town/agents/{id} | Single agent detail |
| GET | /api/town/buildings | All buildings |
| GET | /api/town/events | Recent events |
| GET | /api/town/memory | Shared memory data |
| GET | /api/town/skills | Skill index data |
| POST | /api/town/player/move | Move player character |
| WS | /ws | Real-time state stream |

## Verification

```bash
# Backend regression tests
python -m unittest discover -s backend/tests -q

# Backend syntax/import check
python -m compileall backend

# Frontend typecheck + production build
cd frontend
npm run build
```

## Agents

| Name | Role | Personality |
|------|------|-------------|
| Opus 总舵主 | Chief Architect | Deep thinker, strategic |
| 像素猫 PixelCat | Full-Stack Executor | Patient, precise |
| Codex 协调官 | Coordinator | Fast, decisive |
| Sonnet 审查员 | Code Reviewer | Careful, helpful |
| Haiku 闪电侠 | Speed Runner | Minimal, efficient |
| 鲸鱼 DeepSeek | Bulk Worker | Gentle, diligent |
| OpenHands 工匠 | Builder | Hands-on, practical |
| ARIS 科研框架 | Research Framework | Systematic, rigorous |

## License

MIT
