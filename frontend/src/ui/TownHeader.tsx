import { useTownStore } from '../store/townStore';

export function TownHeader() {
  const state = useTownStore((s) => s.state);
  const connected = useTownStore((s) => s.connected);

  const timeLabel = state ? getTimeLabel(state.time_of_day) : '--';
  const agentCount = state?.agents.length ?? 0;

  return (
    <header className="h-10 flex items-center justify-between px-4 bg-[#0f3460] border-b border-[#e94560]/30">
      <div className="flex items-center gap-3">
        <span className="font-pixel text-[10px] text-[#e94560]">PIXEL AI TOWN</span>
        <span className="text-xs text-town-soft/60">v1.0</span>
      </div>
      <div className="flex items-center gap-4 text-xs text-town-soft/80">
        <span>🕐 {timeLabel}</span>
        <span>👥 {agentCount} agents</span>
        <span>⏱ tick #{state?.tick_count ?? 0}</span>
        <span className={connected ? 'text-green-400' : 'text-red-400'}>
          {connected ? '● 连接中' : '○ 断开'}
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
