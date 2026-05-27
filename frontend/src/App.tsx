import { useEffect, useRef } from 'react'
import * as Phaser from 'phaser'
import { TownScene } from './game/TownScene'
import { DialoguePanel } from './ui/DialoguePanel'
import { useGameStore } from './store/gameStore'
import './App.css'

function App() {
  const gameRef = useRef<Phaser.Game | null>(null)
  const containerRef = useRef<HTMLDivElement>(null)
  const selectedAgent = useGameStore(s => s.selectedAgent)

  useEffect(() => {
    if (!containerRef.current || gameRef.current) return

    gameRef.current = new Phaser.Game({
      type: Phaser.AUTO,
      parent: containerRef.current,
      width: 1280,
      height: 720,
      pixelArt: true,
      backgroundColor: '#1a1a2e',
      scene: [TownScene],
      scale: {
        mode: Phaser.Scale.FIT,
        autoCenter: Phaser.Scale.CENTER_BOTH,
      },
    })

    return () => {
      gameRef.current?.destroy(true)
      gameRef.current = null
    }
  }, [])

  return (
    <div className="game-container">
      <div ref={containerRef} className="phaser-canvas" />
      {selectedAgent && <DialoguePanel agentId={selectedAgent} />}
      <div className="hud">
        <span className="hud-item">Pixel Agent Town v2</span>
      </div>
    </div>
  )
}

export default App
