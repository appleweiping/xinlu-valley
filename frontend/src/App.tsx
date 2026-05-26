import { useEffect, useRef } from 'react';
import { createGame } from './game/PhaserGame';
import { useWebSocket } from './hooks/useWebSocket';
import { useTownStore } from './store/townStore';
import { AgentPanel } from './ui/panels/AgentPanel';
import { BuildingPanel } from './ui/panels/BuildingPanel';
import { EventFeed } from './ui/EventFeed';
import { TownHeader } from './ui/TownHeader';

export default function App() {
  const gameRef = useRef<HTMLDivElement>(null);
  const gameInstance = useRef<Phaser.Game | null>(null);
  const showPanel = useTownStore((s) => s.showPanel);
  const connected = useTownStore((s) => s.connected);

  useWebSocket();

  useEffect(() => {
    if (gameRef.current && !gameInstance.current) {
      gameInstance.current = createGame(gameRef.current);
    }
    return () => {
      gameInstance.current?.destroy(true);
      gameInstance.current = null;
    };
  }, []);

  return (
    <div className="town-shell w-screen h-screen flex flex-col overflow-hidden">
      <TownHeader />
      <div className="flex-1 flex relative">
        {/* Game Canvas */}
        <div ref={gameRef} className="flex-1 relative min-w-0" />

        {!connected && (
          <div className="absolute left-4 top-4 panel w-[min(360px,calc(100vw-2rem))]">
            <div className="panel-title">连接后端中</div>
            <p className="text-xs leading-relaxed text-town-soft/70">
              小镇画面已就绪，正在连接 FastAPI 后端。请确认 backend 运行在 8000 端口，Vite 代理会自动转发 API 和实时通道。
            </p>
          </div>
        )}

        {/* Right Panel */}
        {showPanel && (
          <aside className="town-side-panel w-80 h-full overflow-y-auto border-l border-[#e94560]/20 bg-[#16213e]/95 backdrop-blur">
            {showPanel === 'agent' && <AgentPanel />}
            {showPanel === 'building' && <BuildingPanel />}
          </aside>
        )}

        {/* Event Feed (bottom-left overlay) */}
        <div className="town-event-anchor absolute bottom-4 left-4 w-80">
          <EventFeed />
        </div>

        <div className="town-help absolute bottom-4 right-4 panel max-w-xs">
          <div className="panel-title">操作</div>
          <div className="grid grid-cols-[auto_1fr] gap-x-3 gap-y-1 text-[11px] text-town-soft/70">
            <span className="text-town-soft">左键</span><span>选择角色/建筑，或移动主角</span>
            <span className="text-town-soft">右键拖动</span><span>平移地图</span>
            <span className="text-town-soft">滚轮</span><span>缩放小镇</span>
          </div>
        </div>
      </div>
    </div>
  );
}
