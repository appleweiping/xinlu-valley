"""Build an itch.io-ready zip of the web client.

Usage: python tools/build-itch.py   (run `npm run build` in web/ first,
or pass --build to do it here). Output: workspace/newroad-valley-itch.zip
(workspace/ is gitignored — artifacts never land in the repo).
"""
import shutil
import subprocess
import sys
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DIST = ROOT / "web" / "dist"
OUT = ROOT / "workspace" / "newroad-valley-itch.zip"

PLAY_NOTE = """Newroad Valley — itch.io bundle
================================

EN: Upload this zip to itch.io as an HTML game (set "This file will be
played in the browser" on the zip; viewport 1280x720 or fullscreen).
The entry point is index.html (landing) — play.html is the game itself.
Public builds run on sanitized demo data.

中文：把本 zip 作为 HTML 游戏上传 itch.io（勾选"在浏览器中游玩"，
建议视口 1280x720 或全屏）。index.html 是落地页，play.html 是游戏本体。
公开包使用脱敏演示数据。

License note: art assembled from licensed packs (Sprout Lands, Cute
Fantasy, Mystic Woods free tiers) — redistribution outside deployed
builds is not permitted; see the repo README.
"""


def main() -> None:
    if "--build" in sys.argv:
        npm = shutil.which("npm") or shutil.which("npm.cmd")
        if not npm:
            sys.exit("npm not found on PATH")
        subprocess.run([npm, "run", "build"], cwd=ROOT / "web", check=True)
    if not DIST.exists():
        sys.exit("web/dist missing — run `npm run build` in web/ first")
    OUT.parent.mkdir(exist_ok=True)
    with zipfile.ZipFile(OUT, "w", zipfile.ZIP_DEFLATED) as z:
        for f in DIST.rglob("*"):
            if f.is_file():
                z.write(f, f.relative_to(DIST))
        z.writestr("README-PLAY.txt", PLAY_NOTE)
    print(f"itch bundle: {OUT} ({OUT.stat().st_size // 1024} KB)")


if __name__ == "__main__":
    main()
