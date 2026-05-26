import random
import time
import uuid
from models import TownAgent, TownEvent, ActivityState, Mood
from town_data import TOWN_AGENTS, TOWN_BUILDINGS, ZONE_CENTERS
from config import MAP_WIDTH, MAP_HEIGHT


class TownEngine:
    def __init__(self):
        self.agents: dict[str, TownAgent] = {a.id: a.model_copy() for a in TOWN_AGENTS}
        self.buildings = list(TOWN_BUILDINGS)
        self.events: list[TownEvent] = []
        self.tick_count: int = 0
        self.time_of_day: float = 0.5
        self._adapter_cache: dict = {}

    def update_adapter_cache(self, cache: dict):
        self._adapter_cache = cache

    async def tick(self) -> list[TownEvent]:
        new_events = []
        self.tick_count += 1
        self.time_of_day = (self.time_of_day + 0.002) % 1.0

        for agent in self.agents.values():
            if agent.id == "player":
                continue
            events = self._update_agent(agent)
            new_events.extend(events)

        self.events = (new_events + self.events)[:200]
        return new_events

    def _update_agent(self, agent: TownAgent) -> list[TownEvent]:
        events = []

        if agent.path:
            next_pos = agent.path.pop(0)
            agent.position = next_pos
            agent.current_activity = ActivityState.WALKING
            if not agent.path:
                agent.current_activity = ActivityState.IDLE
                agent.zone = self._get_zone_at(next_pos)
                events.append(self._make_event(
                    agent, "arrived",
                    f"{agent.name} 到达了 {self._zone_name_cn(agent.zone)}"
                ))
            return events

        if random.random() < 0.15:
            new_activity = self._decide_activity(agent)
            if new_activity != agent.current_activity:
                agent.current_activity = new_activity
                events.append(self._make_event(
                    agent, "activity_change",
                    f"{agent.name} 开始{self._activity_desc(new_activity)}"
                ))

        if random.random() < 0.08:
            target_zone = self._pick_destination(agent)
            if target_zone != agent.zone:
                target_pos = ZONE_CENTERS.get(target_zone, (19, 15))
                agent.path = self._simple_path(agent.position, target_pos)
                agent.target_position = target_pos
                events.append(self._make_event(
                    agent, "moving",
                    f"{agent.name} 正在前往 {self._zone_name_cn(target_zone)}"
                ))

        if random.random() < 0.05:
            nearby = self._find_nearby_agents(agent)
            if nearby:
                partner = random.choice(nearby)
                events.append(self._make_event(
                    agent, "chatting",
                    f"{agent.name} 和 {partner.name} 在聊天"
                ))
                agent.current_activity = ActivityState.CHATTING
                agent.interaction_target = partner.id

        if random.random() < 0.1:
            agent.mood = random.choice(list(Mood))

        return events

    def _decide_activity(self, agent: TownAgent) -> ActivityState:
        real_status = self._adapter_cache.get("agent_status", {}).get(agent.id)
        if real_status == "online":
            return ActivityState.WORKING

        recent_sessions = self._adapter_cache.get("recent_sessions", [])
        if any(s.get("agent") == agent.id for s in recent_sessions[-5:]):
            return ActivityState.READING_MEMORY

        zone_activities = {
            "memory_library": ActivityState.READING_MEMORY,
            "skill_workshop": ActivityState.LEARNING_SKILL,
            "devtools_lab": ActivityState.WORKING,
            "dream_garden": ActivityState.RESTING,
            "knowledge_tower": ActivityState.THINKING,
            "resource_market": ActivityState.WORKING,
            "town_hall": ActivityState.THINKING,
            "plaza": ActivityState.IDLE,
            "agent_homes": ActivityState.RESTING,
        }
        return zone_activities.get(agent.zone, ActivityState.IDLE)

    def _pick_destination(self, agent: TownAgent) -> str:
        weights = []
        zones = list(ZONE_CENTERS.keys())
        for z in zones:
            w = 1.0
            if z in agent.preferred_zones:
                w = 3.0
            if z == agent.home_zone:
                w = 2.0
            if z == agent.zone:
                w = 0.3
            weights.append(w)
        return random.choices(zones, weights=weights, k=1)[0]

    def _find_nearby_agents(self, agent: TownAgent) -> list[TownAgent]:
        nearby = []
        for other in self.agents.values():
            if other.id == agent.id or other.id == "player":
                continue
            dx = abs(other.position[0] - agent.position[0])
            dy = abs(other.position[1] - agent.position[1])
            if dx <= 3 and dy <= 3:
                nearby.append(other)
        return nearby

    def _simple_path(self, start: tuple[int, int], end: tuple[int, int]) -> list[tuple[int, int]]:
        path = []
        x, y = start
        tx, ty = end
        steps = max(abs(tx - x), abs(ty - y))
        if steps == 0:
            return []
        for i in range(1, min(steps + 1, 12)):
            nx = x + round((tx - x) * i / steps)
            ny = y + round((ty - y) * i / steps)
            nx = max(0, min(MAP_WIDTH - 1, nx))
            ny = max(0, min(MAP_HEIGHT - 1, ny))
            path.append((nx, ny))
        return path

    def _get_zone_at(self, pos: tuple[int, int]) -> str:
        best_zone = "plaza"
        best_dist = float("inf")
        for zone, center in ZONE_CENTERS.items():
            dist = abs(pos[0] - center[0]) + abs(pos[1] - center[1])
            if dist < best_dist:
                best_dist = dist
                best_zone = zone
        return best_zone

    def _make_event(self, agent: TownAgent, event_type: str, description: str) -> TownEvent:
        return TownEvent(
            id=str(uuid.uuid4())[:8],
            timestamp=time.time(),
            agent_id=agent.id,
            event_type=event_type,
            description=description,
            zone=agent.zone,
        )

    def _zone_name_cn(self, zone: str) -> str:
        names = {
            "town_hall": "镇政厅",
            "memory_library": "记忆图书馆",
            "skill_workshop": "技能工坊",
            "dream_garden": "梦境花园",
            "devtools_lab": "开发实验室",
            "resource_market": "资源市场",
            "knowledge_tower": "知识塔",
            "agent_homes": "居民住宅",
            "plaza": "中央广场",
        }
        return names.get(zone, zone)

    def _activity_desc(self, activity: ActivityState) -> str:
        descs = {
            ActivityState.IDLE: "发呆",
            ActivityState.WALKING: "散步",
            ActivityState.THINKING: "深度思考",
            ActivityState.READING_MEMORY: "阅读记忆",
            ActivityState.LEARNING_SKILL: "学习技能",
            ActivityState.CHATTING: "聊天",
            ActivityState.WORKING: "工作",
            ActivityState.RESTING: "休息",
            ActivityState.EXPLORING: "探索",
        }
        return descs.get(activity, "活动")

    def get_state(self) -> dict:
        return {
            "agents": [a.model_dump() for a in self.agents.values()],
            "buildings": [b.model_dump() for b in self.buildings],
            "events": [e.model_dump() for e in self.events[:30]],
            "tick_count": self.tick_count,
            "time_of_day": self.time_of_day,
        }

    def move_player(self, x: int, y: int):
        player = self.agents.get("player")
        if player:
            target = (max(0, min(MAP_WIDTH - 1, x)), max(0, min(MAP_HEIGHT - 1, y)))
            player.path = self._simple_path(player.position, target)
            player.target_position = target
