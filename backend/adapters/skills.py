import time
from pathlib import Path
from config import SKILL_INDEX_PATH


class SkillAdapter:
    def __init__(self):
        self._cache: dict = {}
        self._cache_time: float = 0
        self._ttl: float = 120.0

    async def refresh(self):
        now = time.time()
        if now - self._cache_time < self._ttl:
            return
        self._cache_time = now

        if not SKILL_INDEX_PATH.exists():
            return

        try:
            content = SKILL_INDEX_PATH.read_text(encoding="utf-8")
            categories = []
            current_cat = None
            skill_count = 0

            for line in content.split("\n"):
                if line.startswith("## "):
                    if current_cat:
                        categories.append(current_cat)
                    current_cat = {"name": line[3:].strip(), "skills": []}
                elif line.startswith("- ") and current_cat is not None:
                    current_cat["skills"].append(line[2:].strip()[:80])
                    skill_count += 1

            if current_cat:
                categories.append(current_cat)

            self._cache["categories"] = categories
            self._cache["total_count"] = skill_count
        except Exception:
            pass

    def get_categories(self) -> list[dict]:
        return self._cache.get("categories", [])

    def get_total_count(self) -> int:
        return self._cache.get("total_count", 0)

    @property
    def is_available(self) -> bool:
        return SKILL_INDEX_PATH.exists()
