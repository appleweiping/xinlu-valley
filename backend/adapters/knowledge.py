import time
from pathlib import Path
from config import KNOWLEDGE_BASE_DIR


class KnowledgeAdapter:
    def __init__(self):
        self._cache: dict = {}
        self._cache_time: float = 0
        self._ttl: float = 120.0

    async def refresh(self):
        now = time.time()
        if now - self._cache_time < self._ttl:
            return
        self._cache_time = now

        if not KNOWLEDGE_BASE_DIR.exists():
            return

        try:
            wiki_dir = KNOWLEDGE_BASE_DIR / "wiki"
            if wiki_dir.exists():
                pages = list(wiki_dir.rglob("*.md"))
                self._cache["page_count"] = len(pages)
                recent = sorted(pages, key=lambda p: p.stat().st_mtime, reverse=True)[:5]
                self._cache["recent_pages"] = [
                    {"name": p.stem, "path": str(p.relative_to(KNOWLEDGE_BASE_DIR))}
                    for p in recent
                ]

            memory_dir = KNOWLEDGE_BASE_DIR / "memory"
            if memory_dir.exists():
                memory_files = list(memory_dir.rglob("*.md"))
                self._cache["memory_count"] = len(memory_files)
        except Exception:
            pass

    def get_overview(self) -> dict:
        return {
            "page_count": self._cache.get("page_count", 0),
            "memory_count": self._cache.get("memory_count", 0),
            "recent_pages": self._cache.get("recent_pages", []),
        }

    @property
    def is_available(self) -> bool:
        return KNOWLEDGE_BASE_DIR.exists()
