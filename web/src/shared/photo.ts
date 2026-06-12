/** Photo mode: snapshot the game canvas into a wood-framed postcard PNG. */

import type Phaser from "phaser";

export interface PhotoOptions {
  caption: string;
  /** false returns the dataURL without downloading (used by the harness) */
  download?: boolean;
}

export function takePhoto(game: Phaser.Game, opts: PhotoOptions): Promise<string> {
  return new Promise((resolve) => {
    game.renderer.snapshot((img) => {
      const shot = img as HTMLImageElement;
      const frame = 26;
      const footer = 34;
      const cv = document.createElement("canvas");
      cv.width = shot.width + frame * 2;
      cv.height = shot.height + frame * 2 + footer;
      const ctx = cv.getContext("2d")!;
      // wooden frame: dark rim, warm board, inner shadow line
      ctx.fillStyle = "#4a3017";
      ctx.fillRect(0, 0, cv.width, cv.height);
      ctx.fillStyle = "#7a5230";
      ctx.fillRect(6, 6, cv.width - 12, cv.height - 12);
      ctx.fillStyle = "#2a1c0e";
      ctx.fillRect(frame - 4, frame - 4, shot.width + 8, shot.height + 8);
      ctx.imageSmoothingEnabled = false;
      ctx.drawImage(shot, frame, frame);
      // caption plaque
      ctx.fillStyle = "#f4e1c1";
      ctx.font = "bold 16px 'Microsoft YaHei', sans-serif";
      ctx.textAlign = "center";
      ctx.fillText(opts.caption, cv.width / 2, cv.height - 13);
      const url = cv.toDataURL("image/png");
      if (opts.download !== false) {
        const a = document.createElement("a");
        a.href = url;
        a.download = `newroad-valley-${Date.now()}.png`;
        a.click();
      }
      resolve(url);
    });
  });
}
