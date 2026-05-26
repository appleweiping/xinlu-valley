import { create } from 'zustand';
import type { TownState, TownAgent, TownBuilding } from '../types';

interface TownStore {
  state: TownState | null;
  connected: boolean;
  selectedAgent: TownAgent | null;
  selectedBuilding: TownBuilding | null;
  showPanel: 'agent' | 'building' | 'memory' | 'skills' | null;

  setState: (state: TownState) => void;
  setConnected: (v: boolean) => void;
  selectAgent: (agent: TownAgent | null) => void;
  selectBuilding: (building: TownBuilding | null) => void;
  setShowPanel: (panel: 'agent' | 'building' | 'memory' | 'skills' | null) => void;
}

export const useTownStore = create<TownStore>((set) => ({
  state: null,
  connected: false,
  selectedAgent: null,
  selectedBuilding: null,
  showPanel: null,

  setState: (state) => set({ state }),
  setConnected: (connected) => set({ connected }),
  selectAgent: (agent) => set({ selectedAgent: agent, selectedBuilding: null, showPanel: agent ? 'agent' : null }),
  selectBuilding: (building) => set({ selectedBuilding: building, selectedAgent: null, showPanel: building ? 'building' : null }),
  setShowPanel: (showPanel) => set({ showPanel }),
}));
