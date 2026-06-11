/** Save file in localStorage. Bed = manual save; door transitions autosave. */

export interface DemoCrop {
  cell: number;          // index into farm soil cells
  title: string;
  progress: number;      // 1..4 growth, 5 = harvested/done
  variety: number;       // lpc crop column
  createdDay: number;
}

export interface SaveData {
  version: 1;
  day: number;
  clockMin: number;
  px: number;
  py: number;
  harvested: number;
  demoCrops: DemoCrop[];
  lang: "zh" | "en";
}

const KEY = "nrv-save-v1";

export function loadSave(): SaveData | null {
  try {
    const raw = localStorage.getItem(KEY);
    if (!raw) return null;
    const d = JSON.parse(raw) as SaveData;
    if (d.version !== 1) return null;
    return d;
  } catch {
    return null;
  }
}

export function writeSave(d: SaveData): void {
  try {
    localStorage.setItem(KEY, JSON.stringify(d));
  } catch {
    /* storage full/denied — ignore */
  }
}
