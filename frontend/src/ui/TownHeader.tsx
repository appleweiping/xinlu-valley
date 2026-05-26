import { useTownStore } from '../store/townStore';

export function TownHeader() {
  const state = useTownStore((s) => s.state);
  const connected = useTownStore((s) => s.connected);

  const timeLabel = state ? getTimeLabel(state.time_of_day) : '--';
  const agentCount = state?.agents.length ?? 0;

  return (
    <header className="town-header min-h-12 flex items-center justify-between gap-3 px-4 bg-[#0f3460]/95 border-b border-[#e94560]/30 shadow-[0_8px_28px_rgba(15,52,96,0.28)]">
      <div className="flex items-center gap-3">
        <span className="inline-flex h-7 w-7 items-center justify-center rounded border border-[#e94560]/40 bg-[#1a1a2e]/70 text-sm shadow-inner">🏘️</span>
        <div>
          <div className="font-pixel text-[10px] text-[#ffd6df]">PIXEL AI TOWN</div>
          <div className="text-[10px] text-town-soft/45">live multi-agent simulation</div>
        </div>
      </div>
      <div className="town-header-stats flex items-center gap-4 text-xs text-town-soft/80">
        <span>🕐 {timeLabel}</span>
        <span>👥 {agentCount} residents</span>
        <span>⏱ tick #{state?.tick_count ?? 0}</span>
        <span className={connected ? 'status-pill status-pill-online' : 'status-pill status-pill-offline'}>
          {connected ? '● live' : '○ offline'}
        </span>
      </div>
    </header>
  );
}

function getTimeLabel(t: number): string {
  const hour = Math.floor(t * 24);
  const min = Math.floor((t * 24 - hour) * 60);
  return `${hour.toString().padStart(2, '0')}:${min.toString().padStart(2, '0')}`;
}
