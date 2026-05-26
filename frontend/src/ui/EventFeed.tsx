import { useTownStore } from '../store/townStore';

export function EventFeed() {
  const events = useTownStore((s) => s.state?.events ?? []);

  return (
    <div className="panel max-h-48 overflow-y-auto">
      <div className="flex items-center justify-between gap-3">
        <div className="panel-title">📜 小镇日志</div>
        <div className="text-[10px] text-town-soft/40">{events.length} events</div>
      </div>
      <div className="space-y-1">
        {events.slice(0, 15).map((event) => (
          <div key={event.id} className="rounded border border-white/5 bg-white/[0.03] px-2 py-1 text-[11px] text-town-soft/70 leading-tight">
            <span className="text-town-soft/40 mr-1">
              {new Date(event.timestamp * 1000).toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })}
            </span>
            {event.description}
          </div>
        ))}
        {events.length === 0 && (
          <div className="rounded border border-dashed border-town-soft/15 px-3 py-4 text-center text-[11px] text-town-soft/40 italic">
            等待小镇活动...
          </div>
        )}
      </div>
    </div>
  );
}
