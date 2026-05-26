from pathlib import Path
import os

# Paths
PROJECT_ROOT = Path(__file__).parent.parent
BACKEND_DIR = Path(__file__).parent
DATABASE_PATH = BACKEND_DIR / "town.db"

# External systems (read-only, configurable via env vars)
AGENT_HUB_URL = os.environ.get("AGENT_HUB_URL", "http://127.0.0.1:9800")
AGENTMEMORY_DB = Path(os.environ.get("AGENTMEMORY_DB", str(Path.home() / ".agentmemory" / "data" / "state_store.db")))
SHARED_MEMORY_DIR = Path(os.environ.get("SHARED_MEMORY_DIR", str(Path.home() / "memory")))
SKILL_INDEX_PATH = Path(os.environ.get("SKILL_INDEX_PATH", str(Path.home() / "SKILL-INDEX.md")))
KNOWLEDGE_BASE_DIR = Path(os.environ.get("KNOWLEDGE_BASE_DIR", str(Path.home() / "knowledgebase")))

# Simulation
TICK_INTERVAL_SECONDS = int(os.environ.get("TICK_INTERVAL", "5"))
ADAPTER_CACHE_TTL_SECONDS = 30
MAP_WIDTH = 40
MAP_HEIGHT = 30
TILE_SIZE = 32

# Server
HOST = "0.0.0.0"
PORT = int(os.environ.get("PORT", "8000"))
