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

  preload() {
    for (const key of Object.keys(AGENT_COLORS)) {
      this.load.image(`agent_${key}`, `/assets/town/agents/agent_${key}.png`);
    }

    for (const zone of ZONES) {
      this.load.image(`building_${zone.id}`, `/assets/town/buildings/building_${zone.id}.png`);
    }
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
    g.fillStyle(0x5f9a52, 1);
    g.fillRect(0, 0, MAP_WIDTH * TILE_SIZE, MAP_HEIGHT * TILE_SIZE);

    for (let y = 0; y < MAP_HEIGHT; y++) {
      for (let x = 0; x < MAP_WIDTH; x++) {
        const isPath = x === 19 || y === 15 || (x >= 5 && x <= 34 && [4, 14, 24].includes(y));
        g.fillStyle(isPath ? 0xd7b982 : ((x + y) % 3 === 0 ? 0x6eae5f : 0x609d53), 1);
        g.fillRect(x * TILE_SIZE, y * TILE_SIZE, TILE_SIZE, TILE_SIZE);
        if (!isPath && (x * 17 + y * 11) % 19 === 0) {
          g.fillStyle(0xffc3d6, 0.75);
          g.fillCircle(x * TILE_SIZE + 22, y * TILE_SIZE + 10, 2);
          g.fillStyle(0xffee99, 0.8);
          g.fillCircle(x * TILE_SIZE + 12, y * TILE_SIZE + 24, 1.6);
        }
      }
    }

    g.lineStyle(1, 0x315a2b, 0.15);
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

      const rect = this.add.rectangle(x + w / 2, y + h / 2, w, h, zone.color, 0.25);
      rect.setStrokeStyle(2, zone.color, 0.6);
      rect.setInteractive();
      rect.on('pointerdown', (_pointer: Phaser.Input.Pointer, _localX: number, _localY: number, event: Phaser.Types.Input.EventData) => {
        event.stopPropagation();
        this.onZoneClick(zone);
      });
      this.zoneGraphics.set(zone.id, rect);

      const building = this.add.image(x + w / 2, y + h / 2 + 4, `building_${zone.id}`);
      const maxDisplay = Math.min(w, h) * 0.92;
      building.setDisplaySize(maxDisplay, maxDisplay);
      building.setDepth(y + h / 2);
      building.setInteractive({ useHandCursor: true });
      building.on('pointerdown', (_pointer: Phaser.Input.Pointer, _localX: number, _localY: number, event: Phaser.Types.Input.EventData) => {
        event.stopPropagation();
        this.onZoneClick(zone);
      });

      const label = this.add.text(x + w / 2, y + h / 2, zone.nameCn, {
        fontSize: '12px',
        color: '#fff8dc',
        fontFamily: '"Microsoft YaHei", sans-serif',
        align: 'center',
        stroke: '#29351f',
        strokeThickness: 3,
      });
      label.setOrigin(0.5);
      label.setDepth(building.depth + 1);
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
        this.input.setDefaultCursor('grabbing');
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
      this.input.setDefaultCursor('default');
    });

    this.input.on('pointerdown', (pointer: Phaser.Input.Pointer) => {
      if (pointer.leftButtonDown()) {
        const worldX = Math.floor(pointer.worldX / TILE_SIZE);
        const worldY = Math.floor(pointer.worldY / TILE_SIZE);
        if (worldX >= 0 && worldX < MAP_WIDTH && worldY >= 0 && worldY < MAP_HEIGHT) {
          fetch('/api/town/player/move', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ x: worldX, y: worldY }),
          })
            .then((response) => response.ok ? response.json() : null)
            .then((data) => {
              if (data?.state) {
                useTownStore.getState().setState(data.state);
              }
            })
            .catch((error) => console.warn('[town] move failed:', error));
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
    container.setDepth(container.y + 1000);

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

    const shadow = this.add.ellipse(0, 13, 25, 8, 0x132414, 0.32);
    const body = this.add.image(0, 0, agent.sprite_key || `agent_${agent.id}`);
    const spriteSize = agent.id === 'player' ? 36 : 32;
    body.setDisplaySize(spriteSize, spriteSize);
    body.setName('body');

    const nameLabel = this.add.text(0, -18, agent.name.split(' ')[0], {
      fontSize: '9px',
      color: '#fff8dc',
      fontFamily: '"Microsoft YaHei", sans-serif',
      stroke: '#000000',
      strokeThickness: 2,
    });
    nameLabel.setOrigin(0.5);

    const bubble = this.add.text(13, -21, '', {
      fontSize: '12px',
      stroke: '#000000',
      strokeThickness: 2,
    });
    bubble.setOrigin(0.5);
    bubble.setName('bubble');

    const container = this.add.container(x, y, [shadow, body, nameLabel, bubble]);
    container.setSize(34, 40);
    container.setDepth(y + 1000);
    container.setInteractive(new Phaser.Geom.Circle(0, 0, 18), Phaser.Geom.Circle.Contains);

    container.on('pointerdown', (_pointer: Phaser.Input.Pointer, _localX: number, _localY: number, event: Phaser.Types.Input.EventData) => {
      event.stopPropagation();
      useTownStore.getState().selectAgent(agent);
    });

    container.on('pointerover', () => {
      body.setDisplaySize(spriteSize * 1.12, spriteSize * 1.12);
      this.input.setDefaultCursor('pointer');
    });
    container.on('pointerout', () => {
      body.setDisplaySize(spriteSize, spriteSize);
      this.input.setDefaultCursor('default');
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
