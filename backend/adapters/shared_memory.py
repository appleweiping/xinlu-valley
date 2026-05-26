import time
from pathlib import Path
from config import SHARED_MEMORY_DIR


class SharedMemoryAdapter:
    def __init__(self):
        self._cache: dict = {}
        self._cache_time: float = 0
        self._ttl: float = 60.0

    async def refresh(self):
        now = time.time()
        if now - self._cache_time < self._ttl:
            return
        self._cache_time = now

        if not SHARED_MEMORY_DIR.exists():
            return

        try:
            self._cache["decisions"] = self._read_dir("decisions")
            self._cache["facts"] = self._read_dir("facts")
            self._cache["lessons"] = self._read_dir("lessons")
            self._cache["sessions"] = self._read_dir("sessions")
            self._cache["preferences"] = self._read_dir("preferences")

            index_path = SHARED_MEMORY_DIR / "INDEX.md"
            if index_path.exists():
                self._cache["index"] = index_path.read_text(encoding="utf-8")[:2000]
        except Exception as e:
            print(f"[shared_memory] refresh error: {e}")

    def _read_dir(self, subdir: str) -> list[dict]:
        dir_path = SHARED_MEMORY_DIR / subdir
        if not dir_path.exists():
            return []
        files = []
        for f in sorted(dir_path.glob("*.md"), key=lambda p: p.stat().st_mtime, reverse=True)[:10]:
            try:
                content = f.read_text(encoding="utf-8")[:500]
                files.append({"name": f.stem, "preview": content[:200], "path": str(f)})
            except Exception:
                continue
        return files

    def get_decisions(self) -> list[dict]:
        return self._cache.get("decisions", [])

    def get_facts(self) -> list[dict]:
        return self._cache.get("facts", [])

    def get_lessons(self) -> list[dict]:
        return self._cache.get("lessons", [])

    def get_sessions(self) -> list[dict]:
        return self._cache.get("sessions", [])

    def get_index(self) -> str:
        return self._cache.get("index", "")

    @property
    def is_available(self) -> bool:
        return SHARED_MEMORY_DIR.exists()
