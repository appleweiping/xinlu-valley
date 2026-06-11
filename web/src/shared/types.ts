/** Data shapes shared by the live bridge (/api/xinlu/*) and demo snapshots (/demo/*.json). */

export interface MemoryData {
  total: number;
  byType: Record<string, number>;
  shelves: { title: string; type: string; project: string; date: string; preview: string }[];
}

export interface WikiData {
  pages: number;
  topics: { name: string; count: number; children?: { name: string; count: number }[] }[];
  recent: { title: string; date: string }[];
}

export interface ResearchData {
  note: string;
  boards: { name: string; status: string; progress: number; cards: string[] }[];
}

export interface SkillsData {
  total: number;
  categories: { name: string; count: number }[];
  featured: { name: string; desc: string; category: string }[];
}

export interface CodeData {
  repos: { name: string; branch: string; lastCommit: string; date: string; dirty: boolean; remote: string }[];
}

export interface TownHallData {
  services: { name: string; ok: boolean; detail: string }[];
  rules: string[];
}

export interface MarketData {
  models: { name: string; provider: string; status: string; role: string }[];
}

export interface FarmData {
  crops: { title: string; stage: number; total: number; kind: string }[];
}
