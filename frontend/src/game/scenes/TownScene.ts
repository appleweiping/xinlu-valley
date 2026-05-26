import Phaser from 'phaser';
import { ZONES, TILE_SIZE, MAP_WIDTH, MAP_HEIGHT, AGENT_COLORS, type ZoneDef } from '../map/zones';
import { useTownStore } from '../../store/townStore';
import type { TownAgent, TownBuilding } from '../../types';

export class TownScene extends Phaser.Scene {
  private agentSprites: Map<string, Phaser.GameObjects.Container> = new Map();
  private zoneGraphics: Map<string, Phaser.GameObjects.Rectangle> = new Map();
  private syncTimer: Phaser.Time.TimerEvent | null = null;

  constructor() {
    super({ key: 'TownScene' });
  }

  create() {
    this.drawMap();
    this.drawZones();
    this.setupCamera();
    this.setupInput();

    this.syncTimer = this.time.addEvent({
      delay: 200,
      loop: true,
      callback: () => this.syncState(),
    });
  }

  shutdown() {
    this.syncTimer?.destroy();
    this.agentSprites.clear();
    this.zoneGraphics.clear();
  }

  private drawMap() {
    const g = this.add.graphics();
    g.fillStyle(0x4a7c3f, 1);
    g.fillRect(0, 0, MAP_WIDTH * TILE_SIZE, MAP_HEIGHT * TILE_SIZE);

    g.lineStyle(1, 0x3d6b34, 0.3);
    for (let x = 0; x <= MAP_WIDTH; x++) {
      g.lineBetween(x * TILE_SIZE, 0, x * TILE_SIZE, MAP_HEIGHT * TILE_SIZE);
    }
    for (let y = 0; y <= MAP_HEIGHT; y++) {
      g.lineBetween(0, y * TILE_SIZE, MAP_WIDTH * TILE_SIZE, y * TILE_SIZE);
    }
  }

  private drawZones() {
    for (const zone of ZONES) {
      const x = zone.x * TILE_SIZE;
      const y = zone.y * TILE_SIZE;
      const w = zone.w * TILE_SIZE;
      const h = zone.h * TILE_SIZE;

      const rect = this.add.rectangle(x + w / 2, y + h / 2, w, h, zone.color, 0.6);
      rect.setStrokeStyle(2, zone.color, 0.9);
      rect.setInteractive();
      rect.on('pointerdown', () => this.onZoneClick(zone));
      this.zoneGraphics.set(zone.id, rect);

      const label = this.add.text(x + w / 2, y + h / 2, zone.nameCn, {
        fontSize: '11px',
        color: '#333333',
        fontFamily: 'sans-serif',
        align: 'center',
      });
      label.setOrigin(0.5);
    }
  }

  private setupCamera() {
    this.cameras.main.setBounds(0, 0, MAP_WIDTH * TILE_SIZE, MAP_HEIGHT * TILE_SIZE);
    this.cameras.main.centerOn((MAP_WIDTH * TILE_SIZE) / 2, (MAP_HEIGHT * TILE_SIZE) / 2);
    this.cameras.main.setZoom(1);

    this.input.on('wheel', (_p: any, _gos: any, _dx: number, dy: number) => {
      const cam = this.cameras.main;
      const newZoom = Phaser.Math.Clamp(cam.zoom - dy * 0.001, 0.5, 2.5);
      cam.setZoom(newZoom);
    });
  }

  private setupInput() {
    let dragging = false;
    let dragStart = { x: 0, y: 0 };
    let camStart = { x: 0, y: 0 };

    this.input.on('pointerdown', (pointer: Phaser.Input.Pointer) => {
      if (pointer.rightButtonDown()) {
        dragging = true;
        dragStart = { x: pointer.x, y: pointer.y };
        camStart = { x: this.cameras.main.scrollX, y: this.cameras.main.scrollY };
      }
    });

    this.input.on('pointermove', (pointer: Phaser.Input.Pointer) => {
      if (dragging) {
        const dx = (pointer.x - dragStart.x) / this.cameras.main.zoom;
        const dy = (pointer.y - dragStart.y) / this.cameras.main.zoom;
        this.cameras.main.scrollX = camStart.x - dx;
        this.cameras.main.scrollY = camStart.y - dy;
      }
    });

    this.input.on('pointerup', () => {
      dragging = false;
    });

    this.input.on('pointerdown', (pointer: Phaser.Input.Pointer) => {
      if (pointer.leftButtonDown() && !pointer.event.defaultPrevented) {
        const worldX = Math.floor(pointer.worldX / TILE_SIZE);
        const worldY = Math.floor(pointer.worldY / TILE_SIZE);
        if (worldX >= 0 && worldX < MAP_WIDTH && worldY >= 0 && worldY < MAP_HEIGHT) {
          fetch('/api/town/player/move', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ x: worldX, y: worldY }),
          });
        }
      }
    });
  }

  private syncState() {
    const state = useTownStore.getState().state;
    if (!state) return;

    for (const agent of state.agents) {
      this.updateAgentSprite(agent);
    }
  }

  private updateAgentSprite(agent: TownAgent) {
    let container = this.agentSprites.get(agent.id);

    if (!container) {
      container = this.createAgentSprite(agent);
      this.agentSprites.set(agent.id, container);
    }

    const targetX = agent.position[0] * TILE_SIZE + TILE_SIZE / 2;
    const targetY = agent.position[1] * TILE_SIZE + TILE_SIZE / 2;

    // Smooth lerp
    const speed = 0.15;
    container.x += (targetX - container.x) * speed;
    container.y += (targetY - container.y) * speed;

    // Update activity bubble
    const bubble = container.getByName('bubble') as Phaser.GameObjects.Text;
    if (bubble) {
      const icons: Record<string, string> = {
        idle: '💤',
        walking: '🚶',
        thinking: '💭',
        reading_memory: '📖',
        learning_skill: '🔧',
        chatting: '💬',
        working: '⚡',
        resting: '😴',
        exploring: '🔍',
      };
      bubble.setText(icons[agent.current_activity] || '');
    }
  }

  private createAgentSprite(agent: TownAgent): Phaser.GameObjects.Container {
    const x = agent.position[0] * TILE_SIZE + TILE_SIZE / 2;
    const y = agent.position[1] * TILE_SIZE + TILE_SIZE / 2;

    const color = AGENT_COLORS[agent.id] || 0xffffff;
    const body = this.add.circle(0, 0, 10, color);
    body.setStrokeStyle(2, 0xffffff, 0.8);

    const nameLabel = this.add.text(0, -18, agent.name.split(' ')[0], {
      fontSize: '8px',
      color: '#ffffff',
      fontFamily: 'sans-serif',
      stroke: '#000000',
      strokeThickness: 2,
    });
    nameLabel.setOrigin(0.5);

    const bubble = this.add.text(0, -28, '', {
      fontSize: '10px',
    });
    bubble.setOrigin(0.5);
    bubble.setName('bubble');

    const container = this.add.container(x, y, [body, nameLabel, bubble]);
    container.setSize(24, 24);
    container.setInteractive(new Phaser.Geom.Circle(0, 0, 12), Phaser.Geom.Circle.Contains);

    container.on('pointerdown', (pointer: Phaser.Input.Pointer) => {
      pointer.event.preventDefault();
      useTownStore.getState().selectAgent(agent);
    });

    container.on('pointerover', () => {
      body.setScale(1.2);
    });
    container.on('pointerout', () => {
      body.setScale(1.0);
    });

    // Idle animation (gentle bob)
    this.tweens.add({
      targets: container,
      y: y - 2,
      duration: 1500 + Math.random() * 500,
      yoyo: true,
      repeat: -1,
      ease: 'Sine.easeInOut',
    });

    return container;
  }

  private onZoneClick(zone: ZoneDef) {
    const state = useTownStore.getState().state;
    if (!state) return;
    const building = state.buildings.find((b) => b.zone === zone.id);
    if (building) {
      useTownStore.getState().selectBuilding(building);
    }
  }
}
