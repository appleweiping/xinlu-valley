import aiosqlite
from pathlib import Path
from config import DATABASE_PATH

CREATE_TABLES_SQL = """
CREATE TABLE IF NOT EXISTS agent_state (
    id TEXT PRIMARY KEY,
    position_x INTEGER NOT NULL,
    position_y INTEGER NOT NULL,
    current_activity TEXT NOT NULL DEFAULT 'idle',
    mood TEXT NOT NULL DEFAULT 'relaxed',
    zone TEXT NOT NULL DEFAULT 'plaza'
);

CREATE TABLE IF NOT EXISTS events (
    id TEXT PRIMARY KEY,
    timestamp REAL NOT NULL,
    agent_id TEXT NOT NULL,
    event_type TEXT NOT NULL,
    description TEXT NOT NULL,
    zone TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS relationships (
    agent_a TEXT NOT NULL,
    agent_b TEXT NOT NULL,
    affinity REAL NOT NULL DEFAULT 0.0,
    interaction_count INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY (agent_a, agent_b)
);

CREATE INDEX IF NOT EXISTS idx_events_timestamp ON events(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_events_agent ON events(agent_id);
"""


async def init_db():
    async with aiosqlite.connect(str(DATABASE_PATH)) as db:
        await db.executescript(CREATE_TABLES_SQL)
        await db.commit()


async def get_db():
    return await aiosqlite.connect(str(DATABASE_PATH))


async def save_agent_state(agent_id: str, x: int, y: int, activity: str, mood: str, zone: str):
    async with aiosqlite.connect(str(DATABASE_PATH)) as db:
        await db.execute(
            """INSERT OR REPLACE INTO agent_state (id, position_x, position_y, current_activity, mood, zone)
               VALUES (?, ?, ?, ?, ?, ?)""",
            (agent_id, x, y, activity, mood, zone),
        )
        await db.commit()


async def save_event(event_id: str, timestamp: float, agent_id: str, event_type: str, description: str, zone: str):
    async with aiosqlite.connect(str(DATABASE_PATH)) as db:
        await db.execute(
            """INSERT OR IGNORE INTO events (id, timestamp, agent_id, event_type, description, zone)
               VALUES (?, ?, ?, ?, ?, ?)""",
            (event_id, timestamp, agent_id, event_type, description, zone),
        )
        await db.commit()


async def get_recent_events(limit: int = 50) -> list[dict]:
    async with aiosqlite.connect(str(DATABASE_PATH)) as db:
        db.row_factory = aiosqlite.Row
        cursor = await db.execute(
            "SELECT * FROM events ORDER BY timestamp DESC LIMIT ?", (limit,)
        )
        rows = await cursor.fetchall()
        return [dict(row) for row in rows]


async def load_agent_states() -> dict[str, dict]:
    async with aiosqlite.connect(str(DATABASE_PATH)) as db:
        db.row_factory = aiosqlite.Row
        cursor = await db.execute("SELECT * FROM agent_state")
        rows = await cursor.fetchall()
        return {row["id"]: dict(row) for row in rows}
