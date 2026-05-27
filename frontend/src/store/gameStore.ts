import { create } from 'zustand'

export interface Agent {
  id: string
  name: string
  role: string
  x: number
  y: number
  state: 'idle' | 'walking' | 'working' | 'talking'
  mood: string
  activity: string
}

interface GameState {
  agents: Agent[]
  selectedAgent: string | null
  dialogueHistory: { role: string; content: string }[]
  connected: boolean
  setAgents: (agents: Agent[]) => void
  selectAgent: (id: string | null) => void
  addDialogue: (msg: { role: string; content: string }) => void
  clearDialogue: () => void
  setConnected: (v: boolean) => void
}

export const useGameStore = create<GameState>((set) => ({
  agents: [
    { id: 'opus', name: 'Opus 总舵主', role: 'Chief Architect', x: 5, y: 5, state: 'idle', mood: 'thoughtful', activity: 'planning' },
    { id: 'pixelcat', name: '像素猫 PixelCat', role: 'Full-Stack Executor', x: 12, y: 8, state: 'idle', mood: 'calm', activity: 'coding' },
    { id: 'sonnet', name: 'Sonnet 审查员', role: 'Code Reviewer', x: 18, y: 12, state: 'idle', mood: 'focused', activity: 'reviewing' },
  ],
  selectedAgent: null,
  dialogueHistory: [],
  connected: false,
  setAgents: (agents) => set({ agents }),
  selectAgent: (id) => set({ selectedAgent: id, dialogueHistory: [] }),
  addDialogue: (msg) => set((s) => ({ dialogueHistory: [...s.dialogueHistory, msg] })),
  clearDialogue: () => set({ dialogueHistory: [] }),
  setConnected: (v) => set({ connected: v }),
}))
