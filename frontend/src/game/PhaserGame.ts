import Phaser from 'phaser';
import { TownScene } from './scenes/TownScene';

export function createGame(parent: HTMLElement): Phaser.Game {
  const config: Phaser.Types.Core.GameConfig = {
    type: Phaser.AUTO,
    parent,
    width: 1280,
    height: 960,
    pixelArt: true,
    backgroundColor: '#2d5a27',
    scale: {
      mode: Phaser.Scale.FIT,
      autoCenter: Phaser.Scale.CENTER_BOTH,
    },
    scene: [TownScene],
  };

  return new Phaser.Game(config);
}
