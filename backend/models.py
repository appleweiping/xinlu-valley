from pydantic import BaseModel
from pydantic import Field
from typing import Optional
from enum import Enum


class ActivityState(str, Enum):
    IDLE = "idle"
    WALKING = "walking"
    THINKING = "thinking"
    READING_MEMORY = "reading_memory"
    LEARNING_SKILL = "learning_skill"
    CHATTING = "chatting"
    WORKING = "working"
    RESTING = "resting"
    EXPLORING = "exploring"


class Mood(str, Enum):
    FOCUSED = "focused"
    RELAXED = "relaxed"
    EXCITED = "excited"
    TIRED = "tired"
    CURIOUS = "curious"
    CONTENT = "content"


class TownAgent(BaseModel):
    id: str
    name: str
    role: str
    personality: str
    position: tuple[int, int]
    target_position: Optional[tuple[int, int]] = None
    current_activity: ActivityState = ActivityState.IDLE
    mood: Mood = Mood.RELAXED
    zone: str = "plaza"
    sprite_key: str = ""
    real_status: Optional[str] = None
    home_zone: str = "agent_homes"
    preferred_zones: list[str] = Field(default_factory=list)
    path: list[tuple[int, int]] = Field(default_factory=list)
    interaction_target: Optional[str] = None


class TownBuilding(BaseModel):
    id: str
    name: str
    name_cn: str
    zone: str
    position: tuple[int, int]
    size: tuple[int, int]
    description: str
    icon: str


class TownEvent(BaseModel):
    id: str
    timestamp: float
    agent_id: str
    event_type: str
    description: str
    zone: str


class AgentRelationship(BaseModel):
    agent_a: str
    agent_b: str
    affinity: float = 0.0
    interaction_count: int = 0


class TownState(BaseModel):
    agents: list[TownAgent]
    buildings: list[TownBuilding]
    events: list[TownEvent]
    tick_count: int = 0
    time_of_day: float = 0.5  # 0.0=midnight, 0.5=noon, 1.0=midnight
