# Pixel AI Town v2 — Full Rebuild

## Project Vision

A living pixel-art Agent Town where AI agents have real intelligence — autonomous decision-making, natural dialogue, task execution, relationships, and emergent behavior. Not a visualization layer, but a true simulation with AI-driven inhabitants.

## Game Studios Workflow

This project uses the Claude-Code-Game-Studios workflow (73 skills, 49 agents).
Skills are at `.claude/skills/game-studios/`.

Start with `/start` to detect project stage and get guided through the workflow.

## Key Requirements

- **Engine**: Phaser 3 (keep — proven, lightweight, pixel-perfect)
- **Frontend**: React + TypeScript + Vite (keep)
- **Backend**: FastAPI + WebSocket (keep, but redesign agent AI layer)
- **Art**: GPT Image 2 for all assets (no external art)
- **Performance**: Low CPU at idle, tick-based simulation (not frame-by-frame AI)
- **AI Agents**: Real LLM-driven decisions, memory, dialogue, task execution
- **Scale**: 8+ agent residents, 9+ zones, expandable

## What to Preserve from v1

- Art assets in `frontend/public/assets/town/` (sprites, tilesets)
- The concept of 8 agent residents mapping to real agent roles
- Read-only adapters to real systems (agentmemory, skills, knowledge)
- WebSocket real-time architecture
- GitHub remote: appleweiping/pixel-ai-town

## What to Rebuild

- Agent AI: Replace random walk with LLM-driven decision engine (cheap model like Haiku/DeepSeek for NPC decisions)
- Dialogue system: Agents can talk to each other and to the player
- Task system: Agents have goals, can complete tasks, report results
- Zone interactions: Each zone has meaningful activities (not just decoration)
- Map: Larger, more detailed, more zones
- UI: Better HUD, dialogue boxes, quest/task panel

## Performance Budget

- Idle CPU: <5% (tick every 5-10s, no per-frame AI)
- Agent AI calls: Batch, use cheapest model (Haiku or DeepSeek)
- Frontend: 60fps rendering, AI logic is backend-only
- Memory: <200MB total (frontend + backend)

## Agent Resources

- Game Studios skills: `.claude/skills/game-studios/`
- Godogen (reference for autonomous gen): `D:\agent-resources\skills\godogen\`
- GSD-2 (spec-driven methodology): `D:\agent-resources\repos\gsd-2\`
- Art generation: media-gen MCP tool (GPT Image 2)
