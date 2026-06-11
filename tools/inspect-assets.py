"""Generate annotated 4x contact sheets of key tilesets for index mapping.

Output: art/_inspect/<name>.png with 16px grid lines and cell indices.
"""
from pathlib import Path
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parent.parent
PACKS = ROOT / "art" / "packs"
OUT = ROOT / "art" / "_inspect"
OUT.mkdir(parents=True, exist_ok=True)

SHEETS = {
    "sprout-grass": (PACKS / "sprout-lands/Tilesets/Grass/Grass.png", 16),
    "sprout-dirt": (PACKS / "sprout-lands/Tilesets/Tilled Dirt/Tilled Dirt.png", 16),
    "sprout-hills": (PACKS / "sprout-lands/Tilesets/Hills/Hills.png", 16),
    "sprout-water": (PACKS / "sprout-lands/Tilesets/Water.png", 16),
    "sprout-house": (PACKS / "sprout-lands/Tilesets/Wooden House.png", 16),
    "sprout-paths": (PACKS / "sprout-lands/Objects/Paths/Paths.png", 16),
    "sprout-fences": (PACKS / "sprout-lands/Tilesets/Fences/Fences.png", 16),
    "sprout-plants": (PACKS / "sprout-lands/Objects/Basic Plants/Basic Plants.png", 16),
    "sprout-biom": (PACKS / "sprout-lands/Objects/Basic Grass Biom things/Basic Grass Biom things 1.png", 16),
    "sprout-furniture": (PACKS / "sprout-lands/Objects/Basic Furniture/Basic Furniture.png", 16),
    "sprout-bridge": (PACKS / "sprout-lands/Objects/Wood Bridge/Wood Bridge.png", 16),
    "sprout-char": (PACKS / "sprout-lands/Characters/Basic Charakter Spritesheet/Basic Charakter Spritesheet.png", 48),
    "sprout-actions": (PACKS / "sprout-lands/Characters/Basic Charakter Actions/Basic Charakter Actions.png", 48),
    "cute-player": (PACKS / "cute-fantasy-rpg/Player/Player.png", 32),
    "cute-grass": (PACKS / "cute-fantasy-rpg/Tiles/Grass_Middle.png", 16),
    "cute-path": (PACKS / "cute-fantasy-rpg/Tiles/Path_Middle.png", 16),
    "cute-house": (PACKS / "cute-fantasy-rpg/Outdoor decoration/House.png", 16),
    "cute-tree": (PACKS / "cute-fantasy-rpg/Trees/Oak_Tree.png", 16),
}

SCALE = 4

def annotate(src: Path, cell: int, dst: Path) -> None:
    img = Image.open(src).convert("RGBA")
    w, h = img.size
    big = img.resize((w * SCALE, h * SCALE), Image.NEAREST)
    # checkerboard background so transparency is visible
    board = Image.new("RGBA", big.size, (255, 255, 255, 255))
    d0 = ImageDraw.Draw(board)
    step = 8 * SCALE
    for y in range(0, big.size[1], step):
        for x in range(0, big.size[0], step):
            if (x // step + y // step) % 2 == 0:
                d0.rectangle([x, y, x + step - 1, y + step - 1], fill=(220, 220, 228, 255))
    board.alpha_composite(big)
    d = ImageDraw.Draw(board)
    cs = cell * SCALE
    cols, rows = w // cell, h // cell
    for cy in range(rows):
        for cx in range(cols):
            x0, y0 = cx * cs, cy * cs
            d.rectangle([x0, y0, x0 + cs - 1, y0 + cs - 1], outline=(255, 0, 90, 160))
            idx = cy * cols + cx
            d.text((x0 + 2, y0 + 1), str(idx), fill=(200, 0, 60, 255))
    board.convert("RGB").save(dst)
    print(f"{dst.name}: {w}x{h} cell={cell} grid={cols}x{rows}")

missing = []
for name, (path, cell) in SHEETS.items():
    if path.exists():
        annotate(path, cell, OUT / f"{name}.png")
    else:
        missing.append(str(path))
if missing:
    print("MISSING:")
    for m in missing:
        print(" ", m)
