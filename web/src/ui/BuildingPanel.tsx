import { useEffect, useState, type ReactNode } from "react";
import { BUILDINGS, AGENTS } from "@/data/town";
import { bus } from "@/shared/bus";
import { getData } from "@/shared/api";
import type {
  MemoryData, WikiData, ResearchData, SkillsData, CodeData, TownHallData, MarketData, FarmData,
} from "@/shared/types";
import { useUI } from "./store";

function usePanelData<T>(live: string, demo: string): T | null {
  const [data, setData] = useState<T | null>(null);
  useEffect(() => {
    let on = true;
    void getData<T>(live, demo).then((d) => on && setData(d)).catch(() => on && setData(null));
    return () => {
      on = false;
    };
  }, [live, demo]);
  return data;
}

const TYPE_COLORS: Record<string, string> = {
  architecture: "#6c5ce7", pattern: "#00b894", preference: "#e84393",
  bug: "#d63031", workflow: "#0984e3", fact: "#e17055", decision: "#fdcb6e",
};

function MemoryPanel({ lang }: { lang: "zh" | "en" }) {
  const d = usePanelData<MemoryData>("/api/xinlu/memory", "memory.json");
  if (!d) return <Loading />;
  return (
    <div>
      <div style={{ display: "flex", flexWrap: "wrap", gap: 4, marginBottom: 8 }}>
        <span className="pixel-chip">{lang === "zh" ? `馆藏 ${d.total} 册` : `${d.total} volumes`}</span>
        {Object.entries(d.byType).map(([t, n]) => (
          <span key={t} className="pixel-chip" style={{ borderColor: TYPE_COLORS[t] ?? "var(--wood)" }}>
            {t} × {n}
          </span>
        ))}
      </div>
      {d.shelves.map((m, i) => (
        <div key={i} className="book-card" style={{ borderLeft: `6px solid ${TYPE_COLORS[m.type] ?? "var(--wood)"}` }}>
          <h4>{m.title}</h4>
          <p>{m.preview}</p>
          <div style={{ marginTop: 4, fontSize: 11, opacity: 0.7 }}>
            {m.project} · {m.type} · {m.date}
          </div>
        </div>
      ))}
    </div>
  );
}

function WikiPanel({ lang }: { lang: "zh" | "en" }) {
  const d = usePanelData<WikiData>("/api/xinlu/wiki", "wiki.json");
  const [open, setOpen] = useState<string | null>(null);
  if (!d) return <Loading />;
  return (
    <div>
      <span className="pixel-chip">{lang === "zh" ? `${d.pages} 页知识` : `${d.pages} pages`}</span>
      <div style={{ margin: "8px 0" }}>
        {d.topics.map((t) => (
          <div key={t.name} className="book-card" style={{ cursor: t.children ? "pointer" : "default" }}
            onClick={() => setOpen(open === t.name ? null : t.name)}>
            <h4>
              {t.children ? (open === t.name ? "▾ " : "▸ ") : "· "}
              {t.name} <span style={{ opacity: 0.6, fontWeight: 400 }}>({t.count})</span>
            </h4>
            {open === t.name && t.children && (
              <div style={{ paddingLeft: 14 }}>
                {t.children.map((c) => (
                  <div key={c.name} style={{ fontSize: 12, padding: "2px 0" }}>
                    · {c.name} <span style={{ opacity: 0.6 }}>({c.count})</span>
                  </div>
                ))}
              </div>
            )}
          </div>
        ))}
      </div>
      <h4 style={{ margin: "10px 0 4px" }}>{lang === "zh" ? "最近更新" : "Recently updated"}</h4>
      {d.recent.map((r, i) => (
        <div key={i} style={{ fontSize: 12, padding: "2px 0" }}>
          📖 {r.title} <span style={{ opacity: 0.6 }}>{r.date}</span>
        </div>
      ))}
    </div>
  );
}

function ResearchPanel({ lang }: { lang: "zh" | "en" }) {
  const d = usePanelData<ResearchData>("/api/xinlu/research", "research.json");
  if (!d) return <Loading />;
  return (
    <div>
      <p style={{ fontSize: 12, opacity: 0.75, marginTop: 0 }}>{d.note}</p>
      {d.boards.map((b) => (
        <div key={b.name} className="book-card">
          <h4>
            {b.name} <span className="pixel-chip">{b.status}</span>
          </h4>
          <div className="bar-outer" style={{ margin: "6px 0" }}>
            <div className="bar-inner" style={{ width: `${b.progress}%` }} />
          </div>
          {b.cards.map((c, i) => (
            <div key={i} style={{ fontSize: 12, padding: "1px 0" }}>· {c}</div>
          ))}
        </div>
      ))}
      <p style={{ fontSize: 11, opacity: 0.6 }}>
        {lang === "zh" ? "演示模式下的看板为虚构内容。" : "Boards are fictional in demo mode."}
      </p>
    </div>
  );
}

function SkillsPanel({ lang }: { lang: "zh" | "en" }) {
  const d = usePanelData<SkillsData>("/api/xinlu/skills", "skills.json");
  if (!d) return <Loading />;
  return (
    <div>
      <span className="pixel-chip">{lang === "zh" ? `${d.total} 个技能配方` : `${d.total} skill recipes`}</span>
      <div style={{ display: "flex", flexWrap: "wrap", gap: 4, margin: "8px 0" }}>
        {d.categories.map((c) => (
          <span key={c.name} className="pixel-chip">
            ⚒ {c.name} × {c.count}
          </span>
        ))}
      </div>
      {d.featured.map((f) => (
        <div key={f.name} className="book-card">
          <h4>⚗ {f.name}</h4>
          <p>{f.desc}</p>
          <div style={{ fontSize: 11, opacity: 0.7, marginTop: 4 }}>{f.category}</div>
        </div>
      ))}
    </div>
  );
}

function CodePanel({ lang }: { lang: "zh" | "en" }) {
  const d = usePanelData<CodeData>("/api/xinlu/code", "code.json");
  if (!d) return <Loading />;
  return (
    <div>
      {d.repos.map((r) => (
        <div key={r.name} className="book-card">
          <h4>
            🌱 {r.name}
            <span className="pixel-chip" style={{ marginLeft: 6 }}>{r.branch}</span>
            {r.dirty && <span className="pixel-chip" style={{ borderColor: "#d63031", color: "#d63031" }}>
              {lang === "zh" ? "未提交" : "dirty"}
            </span>}
          </h4>
          <p>{r.lastCommit}</p>
          <div style={{ fontSize: 11, opacity: 0.7, marginTop: 4 }}>{r.date} · {r.remote}</div>
        </div>
      ))}
    </div>
  );
}

function AgentsPanel({ lang }: { lang: "zh" | "en" }) {
  return (
    <div>
      {AGENTS.map((a) => (
        <div key={a.id} className="book-card" style={{ borderLeft: `6px solid ${a.color}`, display: "flex", gap: 10 }}>
          <div style={{ width: 48, height: 48, overflow: "hidden", position: "relative", flex: "0 0 auto" }}>
            <img src={`/assets/core/characters/${a.id}.png`} alt={a.nameZh}
              style={{ position: "absolute", width: 192, height: 192, left: -12, top: 8, imageRendering: "pixelated" }} />
          </div>
          <div>
            <h4>
              {lang === "zh" ? a.nameZh : a.nameEn}
              <span className="pixel-chip" style={{ marginLeft: 6, color: a.color, borderColor: a.color }}>
                {lang === "zh" ? a.roleZh : a.role}
              </span>
            </h4>
            <p>{lang === "zh" ? a.bioZh : a.bioEn}</p>
            <div style={{ fontSize: 11, opacity: 0.7, marginTop: 3, fontFamily: "monospace" }}>{a.launcher}</div>
          </div>
        </div>
      ))}
    </div>
  );
}

function TownHallPanel({ lang }: { lang: "zh" | "en" }) {
  const d = usePanelData<TownHallData>("/api/xinlu/townhall", "townhall.json");
  if (!d) return <Loading />;
  return (
    <div>
      <h4 style={{ margin: "0 0 6px" }}>{lang === "zh" ? "镇内服务状态" : "Town services"}</h4>
      {d.services.map((s) => (
        <div key={s.name} className="book-card" style={{ borderLeft: `6px solid ${s.ok ? "#5cb83a" : "#d63031"}` }}>
          <h4>{s.ok ? "🟢" : "🔴"} {s.name}</h4>
          <p>{s.detail}</p>
        </div>
      ))}
      <h4 style={{ margin: "12px 0 6px" }}>{lang === "zh" ? "小镇规章（记忆协议摘录）" : "Town rules (memory protocol)"}</h4>
      {d.rules.map((r, i) => (
        <div key={i} style={{ fontSize: 12, padding: "2px 0" }}>📜 {r}</div>
      ))}
    </div>
  );
}

function MarketPanel({ lang }: { lang: "zh" | "en" }) {
  const d = usePanelData<MarketData>("/api/xinlu/market", "market.json");
  if (!d) return <Loading />;
  return (
    <div>
      {d.models.map((m) => (
        <div key={m.name} className="book-card">
          <h4>🛒 {m.name} <span className="pixel-chip">{m.provider}</span></h4>
          <p>{m.role}</p>
          <div style={{ fontSize: 11, opacity: 0.7, marginTop: 3 }}>
            {lang === "zh" ? "状态" : "status"}: {m.status}
          </div>
        </div>
      ))}
      <p style={{ fontSize: 11, opacity: 0.6 }}>
        {lang === "zh" ? "密钥永不显示，仅展示渠道可用性。" : "Keys are never displayed — only channel availability."}
      </p>
    </div>
  );
}

const STAGE_EMOJI = ["🌱", "🌿", "🪴", "🌾", "✅"];

function FarmPanel({ lang }: { lang: "zh" | "en" }) {
  const d = usePanelData<FarmData>("/api/xinlu/farm", "farm.json");
  if (!d) return <Loading />;
  return (
    <div>
      <p style={{ fontSize: 12, opacity: 0.75, marginTop: 0 }}>
        {lang === "zh" ? "每株作物都是一个任务：种下=创建，浇水=推进，收获=完成。" : "Each crop is a task: plant = create, water = progress, harvest = done."}
      </p>
      {d.crops.map((c, i) => (
        <div key={i} className="book-card">
          <h4>
            {STAGE_EMOJI[Math.min(c.stage, 4)]} {c.title}
            <span className="pixel-chip" style={{ marginLeft: 6 }}>{c.kind}</span>
          </h4>
          <div className="bar-outer" style={{ marginTop: 6 }}>
            <div className="bar-inner" style={{ width: `${(c.stage / c.total) * 100}%` }} />
          </div>
          <div style={{ fontSize: 11, opacity: 0.7, marginTop: 3 }}>
            {lang === "zh" ? `生长 ${c.stage}/${c.total}` : `growth ${c.stage}/${c.total}`}
          </div>
        </div>
      ))}
    </div>
  );
}

function HomePanel({ lang }: { lang: "zh" | "en" }) {
  return (
    <div>
      <div className="book-card">
        <h4>🛏 {lang === "zh" ? "休息一下" : "Take a rest"}</h4>
        <p>{lang === "zh" ? "存档保存在浏览器本地。今天也辛苦了。" : "Save lives in your browser. Good work today."}</p>
      </div>
      <div className="book-card">
        <h4>🗺 {lang === "zh" ? "小镇指南" : "Town guide"}</h4>
        <p>
          {lang === "zh"
            ? "市政厅看系统状态；记忆图书馆翻 agent 的长期记忆；知识塔逛 wiki；研究大厅看科研看板；技能工坊翻配方；代码工场收提交；农场照看任务作物。"
            : "Town Hall: system status. Memory Library: long-term agent memories. Knowledge Tower: the wiki. Research Hall: boards. Skill Workshop: recipes. Code Workshop: commits. Farm: task crops."}
        </p>
      </div>
    </div>
  );
}

function Loading() {
  return <div style={{ padding: 24, textAlign: "center", opacity: 0.7 }}>⏳ …</div>;
}

const PANEL_RENDERERS: Record<string, (lang: "zh" | "en") => ReactNode> = {
  memory: (l) => <MemoryPanel lang={l} />,
  wiki: (l) => <WikiPanel lang={l} />,
  research: (l) => <ResearchPanel lang={l} />,
  skills: (l) => <SkillsPanel lang={l} />,
  code: (l) => <CodePanel lang={l} />,
  agents: (l) => <AgentsPanel lang={l} />,
  "town-hall": (l) => <TownHallPanel lang={l} />,
  market: (l) => <MarketPanel lang={l} />,
  farm: (l) => <FarmPanel lang={l} />,
  home: (l) => <HomePanel lang={l} />,
}

export function BuildingPanel() {
  const { openPanel, closePanel, lang } = useUI();
  if (!openPanel) return null;
  const building = BUILDINGS.find((b) => b.id === openPanel);
  if (!building) return null;
  const render = PANEL_RENDERERS[building.panel] ?? (() => <Loading />);

  const close = () => {
    closePanel();
    bus.emit("panel:closed", undefined);
  };

  return (
    <div
      className="fade-in"
      style={{
        position: "absolute", inset: 0, background: "rgba(20,14,28,0.45)",
        display: "flex", alignItems: "center", justifyContent: "center", pointerEvents: "auto",
      }}
      onClick={close}
    >
      <div
        className="wood-panel"
        style={{ width: "min(640px, 94vw)", maxHeight: "84vh", display: "flex", flexDirection: "column" }}
        onClick={(e) => e.stopPropagation()}
      >
        <div className="wood-title">
          <span>
            🏠 {lang === "zh" ? building.nameZh : building.nameEn}
            <span style={{ fontSize: 11, fontWeight: 400, marginLeft: 10, opacity: 0.85 }}>
              {lang === "zh" ? building.descZh : building.descEn}
            </span>
          </span>
          <button className="wood-btn" onClick={close}>✕</button>
        </div>
        <div className="panel-scroll" style={{ padding: 14, overflowY: "auto" }}>
          {render(lang)}
          <div style={{ marginTop: 10, fontSize: 10, opacity: 0.55 }}>
            {lang === "zh" ? "数据源" : "sources"}: {building.sources.join(" · ")}
          </div>
        </div>
      </div>
    </div>
  );
}
