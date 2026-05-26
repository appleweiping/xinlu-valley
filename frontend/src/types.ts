export interface TownAgent {
  id: string;
  name: string;
  role: string;
  personality: string;
  position: [number, number];
  target_position: [number, number] | null;
  current_activity: string;
  mood: string;
  zone: string;
  sprite_key: string;
  real_status: string | null;
  home_zone: string;
  preferred_zones: string[];
  path: [number, number][];
  interaction_target: string | null;
}

export interface TownBuilding {
  id: string;
  name: string;
  name_cn: string;
  zone: string;
  position: [number, number];
  size: [number, number];
  description: string;
  icon: string;
}

export interface TownEvent {
  id: string;
  timestamp: number;
  agent_id: string;
  event_type: string;
  description: string;
  zone: string;
}

export interface TownState {
  agents: TownAgent[];
  buildings: TownBuilding[];
  events: TownEvent[];
  tick_count: number;
  time_of_day: number;
}
