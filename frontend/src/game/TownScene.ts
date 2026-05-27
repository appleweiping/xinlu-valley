import * as Phaser from 'phaser'
import { useGameStore } from '../store/gameStore'

const TILE_SIZE = 32
const MAP_W = 40
const MAP_H = 22

const COLORS = {
  grass: 0x4a7c3f,
  grassLight: 0x5a9c4f,
  path: 0xc4a882,
  water: 0x3d7ea6,
  building: 0x8b6b4a,
}

const AGENT_COLORS: Record<string, number> = {
  opus: 0x9b59b6,
  pixelcat: 0x3498db,
  sonnet: 0xe67e22,
}

export class TownScene extends Phaser.Scene {
  private agentSprites: Map<string, Phaser.GameObjects.Container> = new Map()

  constructor() {
    super({ key: 'TownScene' })
  }

  create() {
    this.createTilemap()
    this.createBuildings()
    this.createAgents()
    this.setupCamera()
    this.setupInput()
    this.startTickLoop()
  }

  private createTilemap() {
    for (let y = 0; y < MAP_H; y++) {
      for (let x = 0; x < MAP_W; x++) {
        const isPath = (y === 10 || x === 20) && !(x < 2 || x > 37 || y < 2 || y > 19)
        const isWater = x > 32 && y > 15
        const color = isWater ? COLORS.water : isPath ? COLORS.path : (x + y) % 7 === 0 ? COLORS.grassLight : COLORS.grass
        const rect = this.add.rectangle(x * TILE_SIZE + TILE_SIZE / 2, y * TILE_SIZE + TILE_SIZE / 2, TILE_SIZE - 1, TILE_SIZE - 1, color)
        rect.setOrigin(0.5)
      }
    }
  }

  private createBuildings() {
    const buildings = [
      { x: 3, y: 3, w: 4, h: 3, name: 'Town Hall', color: 0xd4a574 },
      { x: 14, y: 3, w: 4, h: 3, name: 'Workshop', color: 0x7f8c8d },
      { x: 25, y: 3, w: 4, h: 3, name: 'Library', color: 0x6c5b7b },
    ]

    for (const b of buildings) {
      const rect = this.add.rectangle(
        b.x * TILE_SIZE + (b.w * TILE_SIZE) / 2,
        b.y * TILE_SIZE + (b.h * TILE_SIZE) / 2,
        b.w * TILE_SIZE - 4,
        b.h * TILE_SIZE - 4,
        b.color
      )
      rect.setStrokeStyle(2, 0x2c3e50)

      this.add.text(
        b.x * TILE_SIZE + (b.w * TILE_SIZE) / 2,
        b.y * TILE_SIZE + (b.h * TILE_SIZE) / 2,
        b.name,
        { fontSize: '11px', color: '#ffffff', fontFamily: 'monospace' }
      ).setOrigin(0.5)
    }
  }

  private createAgents() {
    const agents = useGameStore.getState().agents
    for (const agent of agents) {
      const container = this.add.container(agent.x * TILE_SIZE + TILE_SIZE / 2, agent.y * TILE_SIZE + TILE_SIZE / 2)

      const body = this.add.circle(0, 0, 12, AGENT_COLORS[agent.id] || 0xffffff)
      body.setStrokeStyle(2, 0x2c3e50)

      const label = this.add.text(0, -20, agent.name.split(' ')[0], {
        fontSize: '9px', color: '#ffffff', fontFamily: 'monospace',
        backgroundColor: '#00000088', padding: { x: 2, y: 1 },
      }).setOrigin(0.5)

      container.add([body, label])
      container.setSize(24, 24)
      container.setInteractive()

      container.on('pointerdown', () => {
        useGameStore.getState().selectAgent(agent.id)
      })

      this.agentSprites.set(agent.id, container)
    }
  }

  private setupCamera() {
    this.cameras.main.setBounds(0, 0, MAP_W * TILE_SIZE, MAP_H * TILE_SIZE)
    this.cameras.main.setZoom(1.5)
    this.cameras.main.centerOn((MAP_W * TILE_SIZE) / 2, (MAP_H * TILE_SIZE) / 2)
  }

  private setupInput() {
    const cursors = this.input.keyboard!.createCursorKeys()
    const cam = this.cameras.main
    const speed = 5

    this.input.on('wheel', (_p: any, _gos: any, _dx: number, dy: number) => {
      const newZoom = Phaser.Math.Clamp(cam.zoom - dy * 0.001, 0.5, 3)
      cam.setZoom(newZoom)
    })

    this.events.on('update', () => {
      if (cursors.left.isDown) cam.scrollX -= speed
      if (cursors.right.isDown) cam.scrollX += speed
      if (cursors.up.isDown) cam.scrollY -= speed
      if (cursors.down.isDown) cam.scrollY += speed
    })
  }

  private startTickLoop() {
    this.time.addEvent({
      delay: 10000,
      loop: true,
      callback: () => this.simulateTick(),
    })
  }

  private simulateTick() {
    const agents = useGameStore.getState().agents
    const updated = agents.map(a => {
      const newX = Phaser.Math.Clamp(a.x + Phaser.Math.Between(-2, 2), 1, MAP_W - 2)
      const newY = Phaser.Math.Clamp(a.y + Phaser.Math.Between(-2, 2), 1, MAP_H - 2)
      return { ...a, x: newX, y: newY }
    })
    useGameStore.getState().setAgents(updated)

    for (const agent of updated) {
      const sprite = this.agentSprites.get(agent.id)
      if (sprite) {
        this.tweens.add({
          targets: sprite,
          x: agent.x * TILE_SIZE + TILE_SIZE / 2,
          y: agent.y * TILE_SIZE + TILE_SIZE / 2,
          duration: 2000,
          ease: 'Sine.easeInOut',
        })
      }
    }
  }
}
