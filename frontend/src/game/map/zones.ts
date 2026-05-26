export const TILE_SIZE = 32;
export const MAP_WIDTH = 40;
export const MAP_HEIGHT = 30;

export interface ZoneDef {
  id: string;
  name: string;
  nameCn: string;
  x: number;
  y: number;
  w: number;
  h: number;
  color: number;
}

export const ZONES: ZoneDef[] = [
  { id: 'town_hall', name: 'Town Hall', nameCn: '镇政厅', x: 14, y: 2, w: 8, h: 5, color: 0xffe4e1 },
  { id: 'memory_library', name: 'Memory Library', nameCn: '记忆图书馆', x: 2, y: 2, w: 7, h: 5, color: 0xe8f4fd },
  { id: 'skill_workshop', name: 'Skill Workshop', nameCn: '技能工坊', x: 28, y: 2, w: 7, h: 5, color: 0xfff0db },
  { id: 'dream_garden', name: 'Dream Garden', nameCn: '梦境花园', x: 2, y: 12, w: 7, h: 5, color: 0xfffacd },
  { id: 'plaza', name: 'Central Plaza', nameCn: '中央广场', x: 14, y: 11, w: 12, h: 8, color: 0xfff5e6 },
  { id: 'devtools_lab', name: 'Devtools Lab', nameCn: '开发实验室', x: 32, y: 12, w: 6, h: 5, color: 0xf0f0f0 },
  { id: 'resource_market', name: 'Resource Market', nameCn: '资源市场', x: 2, y: 22, w: 7, h: 5, color: 0xe8ffe8 },
  { id: 'knowledge_tower', name: 'Knowledge Tower', nameCn: '知识塔', x: 15, y: 22, w: 5, h: 5, color: 0xe6f3ff },
  { id: 'agent_homes', name: 'Agent Homes', nameCn: '居民住宅', x: 30, y: 22, w: 8, h: 5, color: 0xf5e6ff },
];

export const AGENT_COLORS: Record<string, number> = {
  opus: 0x9b59b6,
  pixelcat: 0xf39c12,
  codex: 0x3498db,
  sonnet: 0x2ecc71,
  haiku: 0x1abc9c,
  deepseek: 0x2980b9,
  openhands: 0x8e44ad,
  aris: 0xe74c3c,
  player: 0xff69b4,
};
