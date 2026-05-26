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
    <div className="w-screen h-screen flex flex-col overflow-hidden">
      <TownHeader />
      <div className="flex-1 flex relative">
        {/* Game Canvas */}
        <div ref={gameRef} className="flex-1 relative" />

        {/* Right Panel */}
        {showPanel && (
          <div className="w-80 h-full overflow-y-auto border-l border-[#e94560]/20 bg-[#16213e]/95 backdrop-blur">
            {showPanel === 'agent' && <AgentPanel />}
            {showPanel === 'building' && <BuildingPanel />}
          </div>
        )}

        {/* Event Feed (bottom-left overlay) */}
        <div className="absolute bottom-4 left-4 w-80">
          <EventFeed />
        </div>
      </div>
    </div>
  );
}
