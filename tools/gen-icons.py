"""Generate PWA icons from the README banner (center square crop).

Usage: python tools/gen-icons.py
Writes web/public/icons/icon-192.png and icon-512.png.
"""
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "docs" / "media" / "banner.png"
OUT = ROOT / "web" / "public" / "icons"


def main() -> None:
    img = Image.open(SRC).convert("RGB")
    w, h = img.size
    side = min(w, h)
    left = (w - side) // 2
    top = (h - side) // 2
    sq = img.crop((left, top, left + side, top + side))
    OUT.mkdir(parents=True, exist_ok=True)
    for size in (512, 192):
        sq.resize((size, size), Image.LANCZOS).save(OUT / f"icon-{size}.png", optimize=True)
        print(f"icon-{size}.png written")


if __name__ == "__main__":
    main()
