import { useTownStore } from '../../store/townStore';

export function BuildingPanel() {
  const building = useTownStore((s) => s.selectedBuilding);
  const setShowPanel = useTownStore((s) => s.setShowPanel);

  if (!building) return null;

  return (
    <div className="p-4 space-y-4">
      <div className="flex items-center justify-between">
        <h2 className="font-pixel text-xs text-[#e94560]">
          {building.icon} {building.name_cn}
        </h2>
        <button
          onClick={() => setShowPanel(null)}
          className="text-town-soft/50 hover:text-town-soft text-lg"
        >
          ×
        </button>
      </div>

      <div className="text-sm text-town-soft/60">{building.name}</div>

      <p className="text-xs text-town-soft/80 leading-relaxed">{building.description}</p>

      <div className="border-t border-[#e94560]/20 pt-3 space-y-2">
        <InfoRow label="区域" value={building.zone} />
        <InfoRow label="位置" value={`(${building.position[0]}, ${building.position[1]})`} />
        <InfoRow label="大小" value={`${building.size[0]}×${building.size[1]} tiles`} />
      </div>
    </div>
  );
}

function InfoRow({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex justify-between text-xs">
      <span className="text-town-soft/50">{label}</span>
      <span className="text-town-soft/90">{value}</span>
    </div>
  );
}
