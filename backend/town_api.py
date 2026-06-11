"""Newroad Valley live-bridge endpoints.

Thin read-only aggregation layer that feeds the v3 web game's building
panels with REAL local data, in exactly the shapes the demo snapshots use
(web/src/shared/types.ts). Every endpoint degrades gracefully: any failing
sub-source yields a partial payload instead of a 500.

Mounted by main.py via:  app.include_router(xinlu_router)
"""
from __future__ import annotations

import json
import os
import re
import subprocess
import time
from datetime import datetime
from pathlib import Path

import httpx
from fastapi import APIRouter

router = APIRouter(prefix="/api/town", tags=["xinlu"])

AGENTMEMORY = "http://localhost:3111"
WIKI_ROOT = Path(r"D:\Research\WEIPING_WIKI\wiki")
RESEARCH_ROOT = Path(r"D:\Research")
SKILL_INDEX = Path(r"D:\agent-resources\SKILL-INDEX.md")
COMPANY_ROOT = Path(r"D:\Company")
PROJECT_ROOT = Path(__file__).resolve().parent.parent
TASKS_FILE = PROJECT_ROOT / "workspace" / "tasks.json"
SELFHEAL_LOG = Path(r"D:\devtools\logs\agentmemory-selfheal.log")


def _mcp_call(name: str, arguments: dict, timeout: float = 12.0) -> dict | None:
    try:
        r = httpx.post(
            f"{AGENTMEMORY}/agentmemory/mcp/call",
            json={"name": name, "arguments": arguments},
            timeout=timeout,
        )
        r.raise_for_status()
        text = r.json()["content"][0]["text"]
        return json.loads(text)
    except Exception:
        return None


def _fmt_date(ts: float) -> str:
    return datetime.fromtimestamp(ts).strftime("%Y-%m-%d")


# --------------------------------------------------------------------- memory
@router.get("/memory")
def memory_panel() -> dict:
    total = 0
    by_type: dict[str, int] = {}
    shelves: list[dict] = []
    try:
        r = httpx.get(f"{AGENTMEMORY}/agentmemory/memories", params={"count": "true"}, timeout=6.0)
        if r.status_code == 200:
            payload = r.json()
            total = int(payload.get("total", payload.get("latestCount", 0)))
    except Exception:
        pass
    found = _mcp_call("memory_smart_search", {"query": "最近的重要决策与修复 recent important decisions", "limit": 10})
    if found:
        for item in found.get("results", [])[:10]:
            title = str(item.get("title", ""))[:80]
            mtype = str(item.get("type", "fact"))
            by_type[mtype] = by_type.get(mtype, 0) + 1
            shelves.append({
                "title": title,
                "type": mtype,
                "project": str(item.get("project", "") or "_global"),
                "date": str(item.get("timestamp", ""))[:10],
                "preview": str(item.get("title", ""))[:160],
            })
    return {"total": total, "byType": by_type, "shelves": shelves}


# ----------------------------------------------------------------------- wiki
@router.get("/wiki")
def wiki_panel() -> dict:
    topics: list[dict] = []
    recent: list[dict] = []
    pages = 0
    if WIKI_ROOT.exists():
        all_md: list[Path] = []
        for sub in sorted(WIKI_ROOT.iterdir()):
            if sub.is_dir() and not sub.name.startswith("."):
                files = list(sub.rglob("*.md"))[:2000]
                all_md.extend(files)
                children = [
                    {"name": c.name, "count": len(list(c.glob("*.md")))}
                    for c in sorted(sub.iterdir()) if c.is_dir() and not c.name.startswith(".")
                ][:6]
                topics.append({"name": sub.name, "count": len(files), "children": children or None})
            elif sub.suffix == ".md":
                all_md.append(sub)
        pages = len(all_md)
        newest = sorted(all_md, key=lambda p: p.stat().st_mtime, reverse=True)[:6]
        recent = [{"title": p.stem, "date": _fmt_date(p.stat().st_mtime)} for p in newest]
    return {"pages": pages, "topics": topics[:8], "recent": recent}


# ------------------------------------------------------------------- research
@router.get("/research")
def research_panel() -> dict:
    """Metadata ONLY: directory names + freshness. Never reads file contents."""
    boards: list[dict] = []
    if RESEARCH_ROOT.exists():
        dirs = [d for d in RESEARCH_ROOT.iterdir() if d.is_dir() and not d.name.startswith((".", "_"))]
        dirs.sort(key=lambda d: d.stat().st_mtime, reverse=True)
        now = time.time()
        for d in dirs[:8]:
            age_days = (now - d.stat().st_mtime) / 86400
            status = "活跃" if age_days < 7 else ("温热" if age_days < 30 else "休眠")
            progress = max(8, min(95, int(100 - age_days)))
            boards.append({
                "name": d.name,
                "status": status,
                "progress": progress,
                "cards": [f"最近更新 {_fmt_date(d.stat().st_mtime)}"],
            })
    return {"note": "联机模式：仅显示目录名与新鲜度，不读取任何科研内容。", "boards": boards}


# --------------------------------------------------------------------- skills
@router.get("/skills")
def skills_panel() -> dict:
    total = 0
    categories: list[dict] = []
    featured: list[dict] = []
    if SKILL_INDEX.exists():
        text = SKILL_INDEX.read_text(encoding="utf-8", errors="ignore")
        current = None
        counts: dict[str, int] = {}
        names: dict[str, list[str]] = {}
        for line in text.splitlines():
            h = re.match(r"^##\s+(.+)", line)
            if h:
                current = h.group(1).strip()
                continue
            item = re.match(r"^[-*]\s+\**`?([\w][\w./-]*)`?\**", line)
            if item and current:
                counts[current] = counts.get(current, 0) + 1
                names.setdefault(current, []).append(item.group(1))
                total += 1
        categories = [{"name": k, "count": v} for k, v in sorted(counts.items(), key=lambda kv: -kv[1])][:8]
        for cat, lst in list(names.items())[:4]:
            if lst:
                featured.append({"name": lst[0], "desc": f"来自 {cat} 分类的技能。", "category": cat})
    return {"total": total, "categories": categories, "featured": featured}


# ----------------------------------------------------------------------- code
@router.get("/code")
def code_panel() -> dict:
    repos: list[dict] = []
    if COMPANY_ROOT.exists():
        for d in sorted(COMPANY_ROOT.iterdir()):
            if not (d / ".git").exists():
                continue
            try:
                def git(*args: str) -> str:
                    return subprocess.run(
                        ["git", "-C", str(d), *args],
                        capture_output=True, text=True, timeout=8,
                    ).stdout.strip()

                branch = git("branch", "--show-current") or "?"
                last = git("log", "-1", "--format=%s")
                date = git("log", "-1", "--format=%cs")
                dirty = bool(git("status", "--porcelain"))
                remote = git("remote", "get-url", "origin").replace("https://", "").removesuffix(".git")
                repos.append({
                    "name": d.name, "branch": branch, "lastCommit": last[:90],
                    "date": date, "dirty": dirty, "remote": remote,
                })
            except Exception:
                continue
    return {"repos": repos}


# ------------------------------------------------------------------- townhall
@router.get("/townhall")
def townhall_panel() -> dict:
    services: list[dict] = []
    try:
        r = httpx.get(f"{AGENTMEMORY}/agentmemory/health", timeout=4.0)
        ok = r.status_code == 200
        detail = "53 个记忆工具在线" if ok else f"HTTP {r.status_code}"
        if ok:
            h = r.json().get("health", {})
            kv = h.get("kvConnectivity", {})
            detail = f"connectionState={h.get('connectionState', '?')} · KV {kv.get('latencyMs', '?')}ms"
    except Exception as exc:
        ok, detail = False, f"不可达：{exc.__class__.__name__}"
    services.append({"name": "agentmemory (端口 3111)", "ok": ok, "detail": detail})
    services.append({"name": "本地数据桥 (端口 8000)", "ok": True, "detail": "你正在通过它读取真实数据。"})
    if SELFHEAL_LOG.exists():
        lines = SELFHEAL_LOG.read_text(encoding="utf-8", errors="ignore").strip().splitlines()
        last = lines[-1] if lines else ""
        services.append({"name": "agentmemory 自愈 watchdog", "ok": "STILL-FAILING" not in last, "detail": last[-160:]})
    return {
        "services": services,
        "rules": [
            "每条记忆必带 type / project / concepts（含 agent 身份标签）",
            "先查重再写入；同主题用 supersedes 更新，不堆流水账",
            "密钥永不入库、永不入记忆、永不入日志",
            "重构之前先存档：commit + tag + push",
            "科研根目录 D:\\Research 神圣不可侵犯",
        ],
    }


# --------------------------------------------------------------------- market
@router.get("/market")
def market_panel() -> dict:
    models: list[dict] = []
    profiles = PROJECT_ROOT / "data" / "model_profiles.json"
    if profiles.exists():
        try:
            for p in json.loads(profiles.read_text(encoding="utf-8"))[:8]:
                env_var = str(p.get("api_key_env", ""))
                has_key = bool(os.getenv(env_var)) if env_var else False
                models.append({
                    "name": str(p.get("label", p.get("id", "?"))),
                    "provider": str(p.get("provider", "?")),
                    "status": "渠道就绪" if has_key else "未配置密钥",
                    "role": str(p.get("description", ""))[:90],
                })
        except Exception:
            pass
    return {"models": models}


# ----------------------------------------------------------------------- farm
@router.get("/farm")
def farm_panel() -> dict:
    crops: list[dict] = []
    if TASKS_FILE.exists():
        try:
            data = json.loads(TASKS_FILE.read_text(encoding="utf-8", errors="ignore"))
            tasks = data if isinstance(data, list) else data.get("tasks", [])
            for t in tasks[:12]:
                status = str(t.get("status", "open")).lower()
                stage = {"open": 1, "todo": 1, "in_progress": 3, "doing": 3, "review": 4, "done": 5, "completed": 5}.get(status, 2)
                crops.append({
                    "title": str(t.get("title", t.get("id", "任务")))[:60],
                    "stage": stage,
                    "total": 5,
                    "kind": status,
                })
        except Exception:
            pass
    return {"crops": crops}
