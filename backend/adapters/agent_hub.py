import httpx
import time
from config import AGENT_HUB_URL


class AgentHubAdapter:
    def __init__(self):
        self._cache: dict = {}
        self._cache_time: float = 0
        self._ttl: float = 30.0

    async def refresh(self):
        now = time.time()
        if now - self._cache_time < self._ttl:
            return
        self._cache_time = now
        try:
            async with httpx.AsyncClient(timeout=5.0) as client:
                resp = await client.get(f"{AGENT_HUB_URL}/status")
                if resp.status_code == 200:
                    self._cache["status"] = resp.json()

                resp = await client.get(f"{AGENT_HUB_URL}/context")
                if resp.status_code == 200:
                    self._cache["context"] = resp.json()
        except Exception:
            pass

    def get_agent_status(self) -> dict[str, str]:
        status = self._cache.get("status", {})
        agents = status.get("agents", {})
        return {k: v.get("status", "offline") for k, v in agents.items()} if isinstance(agents, dict) else {}

    def get_context(self) -> dict:
        return self._cache.get("context", {})

    @property
    def is_available(self) -> bool:
        return bool(self._cache.get("status"))
