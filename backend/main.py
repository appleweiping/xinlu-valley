import os
import json
import httpx
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

app = FastAPI(title="Pixel Agent Town v2")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

DEEPSEEK_API_KEY = os.getenv("DEEPSEEK_API_KEY", "")
DEEPSEEK_BASE_URL = os.getenv("DEEPSEEK_BASE_URL", "https://api.deepseek.com")

AGENT_PERSONALITIES = {
    "opus": {
        "name": "Opus 总舵主",
        "personality": "You are Opus, the Chief Architect. Deep, philosophical, rigorous. You speak with authority but warmth. You think in systems and architectures. You occasionally quote philosophy or make analogies to building cathedrals.",
    },
    "pixelcat": {
        "name": "像素猫 PixelCat",
        "personality": "You are PixelCat, the Full-Stack Executor. Calm, patient, methodical. You speak in short, precise sentences. You love clean code and elegant solutions. You occasionally purr when satisfied.",
    },
    "sonnet": {
        "name": "Sonnet 审查员",
        "personality": "You are Sonnet, the Code Reviewer. Careful, friendly, helpful. You notice details others miss. You give constructive feedback with kindness. You sometimes use poetry metaphors.",
    },
}


class DialogueRequest(BaseModel):
    agent_id: str
    message: str


class DialogueResponse(BaseModel):
    response: str
    agent_id: str
    mood: str


@app.get("/api/health")
async def health():
    return {"status": "ok", "version": "2.0.0"}


@app.post("/api/dialogue", response_model=DialogueResponse)
async def dialogue(req: DialogueRequest):
    agent = AGENT_PERSONALITIES.get(req.agent_id)
    if not agent:
        return DialogueResponse(response="...who?", agent_id=req.agent_id, mood="confused")

    if not DEEPSEEK_API_KEY:
        return DialogueResponse(
            response=f"*{agent['name']} looks at you thoughtfully* I'd love to chat, but my brain isn't connected yet. Set DEEPSEEK_API_KEY to wake me up!",
            agent_id=req.agent_id,
            mood="sleepy",
        )

    prompt = f"""{agent['personality']}

You are in a cozy pixel town. A player just walked up to you and said: "{req.message}"

Respond in character. Keep it short (1-3 sentences). Be natural and conversational. You can reference your current activity or mood."""

    try:
        async with httpx.AsyncClient(timeout=15.0) as client:
            resp = await client.post(
                f"{DEEPSEEK_BASE_URL}/v1/chat/completions",
                headers={"Authorization": f"Bearer {DEEPSEEK_API_KEY}"},
                json={
                    "model": "deepseek-chat",
                    "messages": [{"role": "user", "content": prompt}],
                    "max_tokens": 150,
                    "temperature": 0.8,
                },
            )
            data = resp.json()
            reply = data["choices"][0]["message"]["content"].strip()
    except Exception as e:
        reply = f"*{agent['name']} seems distracted* ...sorry, my thoughts wandered. What were you saying?"

    return DialogueResponse(response=reply, agent_id=req.agent_id, mood="engaged")


@app.get("/api/agents")
async def get_agents():
    return [
        {"id": k, "name": v["name"], "personality": v["personality"][:50] + "..."}
        for k, v in AGENT_PERSONALITIES.items()
    ]
