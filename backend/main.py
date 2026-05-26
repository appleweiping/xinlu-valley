import asyncio
import sys
from pathlib import Path
from contextlib import asynccontextmanager

# Load .env before importing config
from dotenv import load_dotenv
load_dotenv(Path(__file__).parent / ".env")

from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

sys.path.insert(0, str(Path(__file__).parent))

from config import HOST, PORT, TICK_INTERVAL_SECONDS
from db import init_db, save_event, get_recent_events
from town_engine import TownEngine
from websocket_manager import WebSocketManager
from adapters.agent_hub import AgentHubAdapter
from adapters.agentmemory import AgentMemoryAdapter
from adapters.shared_memory import SharedMemoryAdapter
from adapters.skills import SkillAdapter
from adapters.knowledge import KnowledgeAdapter

engine = TownEngine()
ws_manager = WebSocketManager()

hub_adapter = AgentHubAdapter()
memory_adapter = AgentMemoryAdapter()
shared_mem_adapter = SharedMemoryAdapter()
skill_adapter = SkillAdapter()
knowledge_adapter = KnowledgeAdapter()


async def tick_loop():
    while True:
        try:
            await hub_adapter.refresh()
            await memory_adapter.refresh()
            await shared_mem_adapter.refresh()
            await skill_adapter.refresh()
            await knowledge_adapter.refresh()

            engine.update_adapter_cache({
                "agent_status": hub_adapter.get_agent_status(),
                "recent_sessions": memory_adapter.get_recent_sessions(),
            })

            new_events = await engine.tick()

            for event in new_events:
                await save_event(
                    event.id, event.timestamp, event.agent_id,
                    event.event_type, event.description, event.zone
                )

            if ws_manager.client_count > 0:
                await ws_manager.broadcast({
                    "type": "tick",
                    "state": engine.get_state(),
                })
        except Exception as e:
            print(f"[tick] error: {e}")

        await asyncio.sleep(TICK_INTERVAL_SECONDS)


@asynccontextmanager
async def lifespan(app: FastAPI):
    await init_db()
    task = asyncio.create_task(tick_loop())
    print(f"[AI Town] Engine started, tick every {TICK_INTERVAL_SECONDS}s")
    yield
    task.cancel()
    print("[AI Town] Engine stopped")


app = FastAPI(
    title="Pixel AI Town",
    version="1.0.0",
    description="像素风 AI 小镇后端",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/api/health")
async def health():
    return {
        "status": "ok",
        "tick_count": engine.tick_count,
        "clients": ws_manager.client_count,
        "adapters": {
            "agent_hub": hub_adapter.is_available,
            "agentmemory": memory_adapter.is_available,
            "shared_memory": shared_mem_adapter.is_available,
            "skills": skill_adapter.is_available,
            "knowledge": knowledge_adapter.is_available,
        },
    }


@app.get("/api/town/state")
async def get_town_state():
    return engine.get_state()


@app.get("/api/town/agents")
async def get_agents():
    return [a.model_dump() for a in engine.agents.values()]


@app.get("/api/town/agents/{agent_id}")
async def get_agent(agent_id: str):
    agent = engine.agents.get(agent_id)
    if not agent:
        return {"error": "not found"}
    return agent.model_dump()


@app.get("/api/town/buildings")
async def get_buildings():
    return [b.model_dump() for b in engine.buildings]


@app.get("/api/town/events")
async def get_events(limit: int = 30):
    return [e.model_dump() for e in engine.events[:limit]]


@app.get("/api/town/memory")
async def get_memory_data():
    return {
        "decisions": shared_mem_adapter.get_decisions(),
        "facts": shared_mem_adapter.get_facts(),
        "lessons": shared_mem_adapter.get_lessons(),
        "sessions": shared_mem_adapter.get_sessions(),
        "index_preview": shared_mem_adapter.get_index()[:500],
    }


@app.get("/api/town/skills")
async def get_skills_data():
    return {
        "total_count": skill_adapter.get_total_count(),
        "categories": skill_adapter.get_categories()[:10],
    }


@app.get("/api/town/knowledge")
async def get_knowledge_data():
    return knowledge_adapter.get_overview()


class MoveRequest(BaseModel):
    x: int
    y: int


@app.post("/api/town/player/move")
async def move_player(req: MoveRequest):
    engine.move_player(req.x, req.y)
    return {"ok": True}


@app.post("/api/town/tick")
async def manual_tick():
    events = await engine.tick()
    return {"events": [e.model_dump() for e in events]}


@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await ws_manager.connect(websocket)
    try:
        await websocket.send_json({"type": "init", "state": engine.get_state()})
        while True:
            data = await websocket.receive_text()
            if data == "ping":
                await websocket.send_json({"type": "pong"})
    except WebSocketDisconnect:
        ws_manager.disconnect(websocket)
    except Exception:
        ws_manager.disconnect(websocket)


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host=HOST, port=PORT, reload=True)
