import aiosqlite
import time
from pathlib import Path
from config import AGENTMEMORY_DB


class AgentMemoryAdapter:
    def __init__(self):
        self._cache: dict = {}
        self._cache_time: float = 0
        self._ttl: float = 30.0

    async def refresh(self):
        now = time.time()
        if now - self._cache_time < self._ttl:
            return
        self._cache_time = now

        if not AGENTMEMORY_DB.exists():
            return

        try:
            async with aiosqlite.connect(str(AGENTMEMORY_DB)) as db:
                db.row_factory = aiosqlite.Row

                cursor = await db.execute(
                    "SELECT name FROM sqlite_master WHERE type='table'"
                )
                tables = [row[0] for row in await cursor.fetchall()]

                if "sessions" in tables:
                    cursor = await db.execute(
                        "SELECT * FROM sessions ORDER BY rowid DESC LIMIT 10"
                    )
                    self._cache["sessions"] = [dict(row) for row in await cursor.fetchall()]

                if "observations" in tables:
                    cursor = await db.execute(
                        "SELECT * FROM observations ORDER BY rowid DESC LIMIT 20"
                    )
                    self._cache["observations"] = [dict(row) for row in await cursor.fetchall()]

                if "lessons" in tables:
                    cursor = await db.execute(
                        "SELECT * FROM lessons ORDER BY rowid DESC LIMIT 10"
                    )
                    self._cache["lessons"] = [dict(row) for row in await cursor.fetchall()]
        except Exception:
            pass

    def get_recent_sessions(self) -> list[dict]:
        return self._cache.get("sessions", [])

    def get_recent_observations(self) -> list[dict]:
        return self._cache.get("observations", [])

    def get_lessons(self) -> list[dict]:
        return self._cache.get("lessons", [])

    @property
    def is_available(self) -> bool:
        return AGENTMEMORY_DB.exists()
