import { create } from "zustand";

export type Lang = "zh" | "en";

interface UIState {
  lang: Lang;
  live: boolean;
  dialogueAgent: string | null;
  openPanel: string | null; // building id
  clock: { day: number; hour: number; minute: number; season: string };
  setLang(l: Lang): void;
  setLive(v: boolean): void;
  openDialogue(agentId: string): void;
  closeDialogue(): void;
  openBuilding(buildingId: string): void;
  closePanel(): void;
  setClock(c: UIState["clock"]): void;
}

export const useUI = create<UIState>((set) => ({
  lang: "zh",
  live: false,
  dialogueAgent: null,
  openPanel: null,
  clock: { day: 1, hour: 8, minute: 0, season: "春" },
  setLang: (lang) => set({ lang }),
  setLive: (live) => set({ live }),
  openDialogue: (dialogueAgent) => set({ dialogueAgent }),
  closeDialogue: () => set({ dialogueAgent: null }),
  openBuilding: (openPanel) => set({ openPanel }),
  closePanel: () => set({ openPanel: null }),
  setClock: (clock) => set({ clock }),
}));
