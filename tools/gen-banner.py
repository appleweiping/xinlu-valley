"""Generate the README banner via the official gpt-image-2 channel.

Reads GPTIMAGE_URL / GPTIMAGE_KEY from art/.env (gitignored). Output:
docs/media/banner.png. Run: python tools/gen-banner.py
"""
from __future__ import annotations

import base64
import os
import sys
from pathlib import Path

import httpx
from dotenv import load_dotenv

ROOT = Path(__file__).resolve().parent.parent
load_dotenv(ROOT / "art" / ".env")

URL = os.environ.get("GPTIMAGE_URL", "")
KEY = os.environ.get("GPTIMAGE_KEY", "")
OUT = ROOT / "docs" / "media" / "banner.png"

PROMPT = (
    "16-bit pixel art game banner, wide cinematic composition, Stardew Valley "
    "aesthetic, golden-hour light over a cozy farming village called Newroad "
    "Valley: timber A-frame cottages with colorful shingle roofs (teal, plum, "
    "gold, sage green), a stone town hall with a glowing window, dirt paths, "
    "tulip beds, wooden fences, a small farm plot with sprouting crops, a "
    "winding river with a wooden bridge, big oak trees. In the plaza stand "
    "tiny charming characters: a girl with long ink-black hair and a dusty "
    "blue beret, a small red fox storyteller, a round white robot with teal "
    "trim, a little blue whale, a rose songbird, a golden chick, a scholar "
    "owl with glasses, a ginger cat, and a purple-robed sage. Warm pastel "
    "palette, soft dithered clouds, no text, no watermark, crisp clean "
    "pixels, detailed but readable, masterpiece quality pixel art"
)


def main() -> int:
    if not URL or not KEY:
        print("BLOCKED: GPTIMAGE_URL/GPTIMAGE_KEY not configured in art/.env")
        return 2
    print("requesting gpt-image-2 banner (1536x1024)…")
    r = httpx.post(
        URL,
        headers={"Authorization": f"Bearer {KEY}", "Content-Type": "application/json"},
        json={"model": "gpt-image-2", "prompt": PROMPT, "size": "1536x1024", "quality": "high", "n": 1},
        timeout=300.0,
    )
    if r.status_code != 200:
        print(f"FAILED: HTTP {r.status_code}: {r.text[:300]}")
        return 1
    data = r.json().get("data") or []
    if not data:
        print("FAILED: empty data")
        return 1
    item = data[0]
    if "b64_json" in item:
        img = base64.b64decode(item["b64_json"])
    elif "url" in item:
        img = httpx.get(item["url"], timeout=120.0).content
    else:
        print("FAILED: no image payload")
        return 1
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_bytes(img)
    print(f"OK: {OUT} ({len(img)//1024} KB)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
