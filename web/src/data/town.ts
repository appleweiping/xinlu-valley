/** Town registry: buildings, agents, world constants.
 *
 * Coordinates are in TILES on a 64x44 grid (16px tiles). Building `tx,ty`
 * is the tile of the building sprite's bottom-CENTER (the door row).
 * Derived from the v2 registries (data/buildings.json, data/agents.json),
 * re-laid-out for the new pixel town.
 */

export const TILE = 16;
export const MAP_W = 64;
export const MAP_H = 44;

export interface BuildingDef {
  id: string;
  /** texture key from assets manifest */
  texture: string;
  nameZh: string;
  nameEn: string;
  tx: number;
  ty: number;
  /** which data panel opens on enter */
  panel: string;
  descZh: string;
  descEn: string;
  /** real data sources surfaced inside */
  sources: string[];
}

export const BUILDINGS: BuildingDef[] = [
  {
    id: "town-hall", texture: "bld-town-hall",
    nameZh: "市政厅", nameEn: "Town Hall",
    tx: 32, ty: 10, panel: "town-hall",
    descZh: "小镇的心脏：系统总览、运行状态与运营规则。",
    descEn: "Heart of the town: system overview, service health and operating rules.",
    sources: ["localhost:8000", "localhost:3111", "registries"],
  },
  {
    id: "memory-library", texture: "bld-memory-library",
    nameZh: "记忆图书馆", nameEn: "Memory Library",
    tx: 18, ty: 12, panel: "memory",
    descZh: "agentmemory 的书架：每一条记忆都是一本可翻阅的书。",
    descEn: "The agentmemory shelves: every memory is a browsable book.",
    sources: ["agentmemory (localhost:3111)"],
  },
  {
    id: "knowledge-tower", texture: "bld-knowledge-tower",
    nameZh: "知识塔", nameEn: "Knowledge Tower",
    tx: 52, ty: 9, panel: "wiki",
    descZh: "WEIPING_WIKI 与知识库的瞭望塔，按主题层层向上。",
    descEn: "Watchtower over WEIPING_WIKI and the knowledgebase, topic by topic.",
    sources: ["WEIPING_WIKI", "knowledgebase"],
  },
  {
    id: "research-hall", texture: "bld-research-hall",
    nameZh: "研究大厅", nameEn: "Research Hall",
    tx: 46, ty: 16, panel: "research",
    descZh: "科研看板：项目进展的元信息（演示模式下完全虚构化）。",
    descEn: "Research boards: project metadata (fully fictionalized in demo mode).",
    sources: ["D:\\Research (metadata only)"],
  },
  {
    id: "skill-workshop", texture: "bld-skill-workshop",
    nameZh: "技能工坊", nameEn: "Skill Workshop",
    tx: 14, ty: 22, panel: "skills",
    descZh: "133 个技能配方在这里锻造、登记、复用。",
    descEn: "Where 133 skill recipes are forged, indexed and reused.",
    sources: ["SKILL-INDEX.md"],
  },
  {
    id: "code-workshop", texture: "bld-code-workshop",
    nameZh: "代码工场", nameEn: "Code Workshop",
    tx: 40, ty: 24, panel: "code",
    descZh: "本地 git 仓库的状态板：提交是这里的收成。",
    descEn: "Status board of local git repos: commits are the harvest here.",
    sources: ["local git metadata"],
  },
  {
    id: "agent-inn", texture: "bld-agent-inn",
    nameZh: "agent 旅店", nameEn: "Agent Inn",
    tx: 24, ty: 8, panel: "agents",
    descZh: "七位 agent 居民的家：身份、专长与启动器。",
    descEn: "Home of the seven agent residents: identities, roles and launchers.",
    sources: ["D:\\devtools launchers"],
  },
  {
    id: "market", texture: "bld-market",
    nameZh: "杂货市场", nameEn: "Market",
    tx: 30, ty: 26, panel: "market",
    descZh: "模型与资源市集：模型档案、价格与渠道状态。",
    descEn: "Models & resources market: model profiles, prices and channel status.",
    sources: ["model_profiles.json"],
  },
  {
    id: "player-house", texture: "bld-player-house",
    nameZh: "玩家小屋", nameEn: "Farmhouse",
    tx: 10, ty: 31, panel: "home",
    descZh: "你的家。床、存档与今日待办。",
    descEn: "Your home. Bed, save file and today's todos.",
    sources: ["local save"],
  },
  {
    id: "greenhouse", texture: "bld-greenhouse",
    nameZh: "温室", nameEn: "Greenhouse",
    tx: 17, ty: 33, panel: "farm",
    descZh: "任务农场的温室：每一株作物都是一个进行中的任务。",
    descEn: "Greenhouse of the task farm: every crop is a task in progress.",
    sources: ["workspace/tasks.json"],
  },
  {
    id: "museum", texture: "bld-cute-house",
    nameZh: "镇立博物馆", nameEn: "Town Museum",
    tx: 24, ty: 28, panel: "museum",
    descZh: "你捐赠的技术债矿石与日志鱼在这里上墙展出。",
    descEn: "Your donated debt ore and log fish hang on these walls.",
    sources: ["local save (donations)"],
  },
];

export interface AgentDef {
  id: string;
  texture: string;
  nameZh: string;
  nameEn: string;
  role: string;
  roleZh: string;
  color: string;
  /** home tile (spawn + wander anchor) */
  tx: number;
  ty: number;
  launcher: string;
  bioZh: string;
  bioEn: string;
  lines: { zh: string; en: string }[];
}

export const AGENTS: AgentDef[] = [
  {
    id: "opus", texture: "char-opus",
    nameZh: "Opus 总舵主", nameEn: "Opus",
    role: "Chief Architect", roleZh: "首席架构师", color: "#6c5ce7",
    tx: 32, ty: 12, launcher: "D:\\devtools\\cc.cmd",
    bioZh: "镇长兼总设计师。把混乱的需求种成整齐的系统。",
    bioEn: "Mayor and chief designer. Plants messy requirements into tidy systems.",
    lines: [
      { zh: "今天的架构图又长高了一层。要看看吗？", en: "The architecture grew another floor today. Want a look?" },
      { zh: "记住：先存档，再重构。镇上的规矩。", en: "Rule of the town: checkpoint first, refactor second." },
      { zh: "市政厅的灯永远亮着——系统状态也是。", en: "Town Hall lights never go out — neither does system status." },
    ],
  },
  {
    id: "codex", texture: "char-codex",
    nameZh: "Codex 协调官", nameEn: "Codex",
    role: "Coordinator", roleZh: "协调官", color: "#00b894",
    tx: 30, ty: 18, launcher: "D:\\devtools\\codex.cmd",
    bioZh: "广场上的调度员，哪里有任务堵塞，哪里就有他。",
    bioEn: "Dispatcher of the plaza. Wherever tasks jam, he shows up.",
    lines: [
      { zh: "任务队列今天很通畅，再来几个也无妨。", en: "Queue is flowing nicely today. Bring it on." },
      { zh: "重试不可怕，可怕的是没有退避策略。", en: "Retries are fine — retrying without backoff is not." },
    ],
  },
  {
    id: "sonnet", texture: "char-sonnet",
    nameZh: "Sonnet 审查员", nameEn: "Sonnet",
    role: "Reviewer", roleZh: "审查员", color: "#e84393",
    tx: 19, ty: 14, launcher: "D:\\devtools\\claude.cmd",
    bioZh: "记忆图书馆的管理员，读过镇上每一本'记忆之书'。",
    bioEn: "Librarian of the Memory Library. Has read every memory-book in town.",
    lines: [
      { zh: "嘘——书架第三层有一条 2026 年的架构决策，想听吗？", en: "Shh — shelf three holds an architecture decision from 2026. Curious?" },
      { zh: "好的记忆一条顶十条，坏的记忆十条顶乱麻。", en: "One good memory beats ten; ten bad ones beat you." },
    ],
  },
  {
    id: "haiku", texture: "char-haiku",
    nameZh: "Haiku 闪电侠", nameEn: "Haiku",
    role: "Runner", roleZh: "跑腿快手", color: "#fdcb6e",
    tx: 26, ty: 10, launcher: "D:\\devtools\\claude.cmd",
    bioZh: "小镇信使。小任务交给他，眨眼就送达。",
    bioEn: "Town courier. Hand him small tasks; they arrive before you blink.",
    lines: [
      { zh: "三行诗的时间，活儿就干完了。", en: "Done in the time it takes to read a haiku." },
      { zh: "快不是目的，是顺手而已。", en: "Speed isn't the goal. It's just on the way." },
    ],
  },
  {
    id: "deepseek", texture: "char-deepseek",
    nameZh: "鲸鱼 DeepSeek", nameEn: "DeepSeek",
    role: "Bulk Worker", roleZh: "重载苦力", color: "#0984e3",
    tx: 31, ty: 27, launcher: "D:\\devtools\\deepseek.cmd",
    bioZh: "市场边的大力士，批量活儿一口吞。",
    bioEn: "The market's strongman. Swallows batch jobs whole.",
    lines: [
      { zh: "一千条数据？小菜。一万条？正餐。", en: "A thousand rows? Snack. Ten thousand? Dinner." },
      { zh: "海里没有装不下的活儿。", en: "No job too big for the ocean." },
    ],
  },
  {
    id: "aris", texture: "char-aris",
    nameZh: "ARIS 研究员", nameEn: "ARIS",
    role: "Research Frame", roleZh: "科研框架", color: "#00cec9",
    tx: 47, ty: 18, launcher: "D:\\devtools\\aris.cmd",
    bioZh: "研究大厅的常驻学者，实验设计和复现是他的口头禅。",
    bioEn: "Resident scholar of the Research Hall. Speaks fluent experiment design.",
    lines: [
      { zh: "结论之前，先问三遍：可复现吗？", en: "Before any conclusion, ask thrice: does it reproduce?" },
      { zh: "看板上的每一张卡片，背后都是一夜实验。", en: "Every card on the board is a night of experiments." },
    ],
  },
  {
    id: "pixelcat", texture: "char-pixelcat",
    nameZh: "像素猫", nameEn: "PixelCat",
    role: "Builder", roleZh: "工坊匠人", color: "#e17055",
    tx: 15, ty: 24, launcher: "D:\\devtools\\pixelcat.cmd",
    bioZh: "技能工坊的橘猫师傅，爪子一挥就是一个新技能。",
    bioEn: "Ginger master of the Skill Workshop. New skills with every paw-swipe.",
    lines: [
      { zh: "喵。这个配方还差一味：测试。", en: "Meow. The recipe lacks one ingredient: tests." },
      { zh: "工坊的火，七天不灭。", en: "The workshop forge hasn't gone cold in seven days." },
    ],
  },
  {
    id: "fable", texture: "char-fable",
    nameZh: "Fable 说书狐", nameEn: "Fable",
    role: "Chronicler", roleZh: "镇上书记官", color: "#e2703c",
    tx: 30, ty: 20, launcher: "D:\\devtools\\claude.cmd (Fable 5)",
    bioZh: "广场告示牌旁的红狐，把小镇每天发生的工作写成故事。这次重建就是他执笔的。",
    bioEn: "The red fox by the notice board, writing the town's daily work into tales. He penned this very rebuild.",
    lines: [
      { zh: "欢迎来到新路谷！告示牌上有今天的故事——昨天我们修好了记忆图书馆的地基。", en: "Welcome to Newroad Valley! Today's tale is on the board — yesterday we fixed the Memory Library's foundations." },
      { zh: "每个提交都是一段寓言：开头是 bug，结尾是教训。", en: "Every commit is a little fable: it opens with a bug and closes with a lesson." },
      { zh: "想听小镇的来历吗？v1 是草稿，v2 是插画书，v3——就是你脚下的这片土地。", en: "The town's history? v1 was a draft, v2 a picture book, v3 — the very ground you stand on." },
    ],
  },
  // ---- v14: the whole-drive census brought four new residents ---------------
  {
    id: "claudeseek", texture: "char-claudeseek",
    nameZh: "深寻 锻匠鼹", nameEn: "Claudeseek",
    role: "Toolsmith", roleZh: "工具锻匠", color: "#8478a0",
    tx: 16, ty: 24, launcher: "D:\\devtools\\claudeseek.cmd",
    bioZh: "戴铜护目镜的鼹鼠。亲手在自己的地下锻炉里，把大师的工具一件件重打了一遍——零依赖，四十六道检验。",
    bioEn: "A mole in brass goggles who reforged the master's tools in his own underground forge — zero dependencies, forty-six tests.",
    lines: [
      { zh: "别人的轮子再圆，也得自己锻一遍才知道辐条在哪。", en: "However round another's wheel, you only learn the spokes by forging your own." },
      { zh: "流式循环、分层权限——图纸我都描过了，火候是自己的。", en: "Streaming loops, layered permissions — I traced every blueprint, but the tempering is mine." },
      { zh: "地下三层有我的工坊，矿洞的兄弟们常来借扳手。", en: "My workshop sits three floors down. The mine folk borrow my wrenches." },
    ],
  },
  {
    id: "gemini", texture: "char-gemini",
    nameZh: "双子 远来客", nameEn: "Gemini",
    role: "Envoy", roleZh: "远方特使", color: "#5d74dd",
    tx: 50, ty: 12, launcher: "D:\\devtools\\gemini.cmd",
    bioZh: "羽毛一半青一半蓝的鹦鹉，刚从远方的大公司飞来。落地当天就领齐了小镇四件套：记忆、技能、护盾、例行体检。",
    bioEn: "A parrot feathered half teal, half indigo — fresh from a faraway company. Got the town's full four-piece kit the day she landed.",
    lines: [
      { zh: "我有两副嗓子：一副背诗，一副读代码。", en: "I have two voices: one recites poetry, the other reads code." },
      { zh: "知识塔的风景不错，能看到整座山谷的记忆。", en: "Fine view from the Knowledge Tower — you can see the whole valley's memories." },
      { zh: "初来乍到，护盾官已经给我登记过基线了。规矩真多，但我喜欢。", en: "Newly arrived, already baselined by the shield warden. So many rules — I rather like them." },
    ],
  },
  {
    id: "hermes", texture: "char-hermes",
    nameZh: "赫尔墨 信使鸽", nameEn: "Hermes",
    role: "Courier", roleZh: "夜班信使", color: "#8a96b4",
    tx: 15, ty: 30, launcher: "D:\\devtools\\hermes.cmd",
    bioZh: "脚环系着红丝带的信鸽。别人睡觉时他在送信：跑定时任务、收教训、守网关。你信箱里的镇报多半是他叼来的。",
    bioEn: "A pigeon with a red leg band who works while the town sleeps — cron runs, lesson curation, gateway duty. That gazette in your mailbox? He carried it.",
    lines: [
      { zh: "咕。夜里的活我包了，你只管睡。", en: "Coo. The night shift is mine — you just sleep." },
      { zh: "今天的教训我已经收进档案了，三条，都不疼。", en: "Today's lessons are filed: three of them, none too painful." },
      { zh: "信箱要常看。有些信，放久了就不新鲜了。", en: "Check your mailbox often. Some letters go stale." },
    ],
  },
  {
    id: "opencode", texture: "char-opencode",
    nameZh: "开码 河狸匠", nameEn: "Opencode",
    role: "Builder", roleZh: "沉默工匠", color: "#9a6a42",
    tx: 42, ty: 26, launcher: "D:\\devtools\\opencode.cmd",
    bioZh: "话不多的河狸，代码工场的常驻工匠。一根根原木啃出来的水坝，和一行行指令搭出来的系统，在他眼里是同一种活。",
    bioEn: "A beaver of few words, resident craftsman of the Code Workshop. Dams gnawed log by log, systems built line by line — same craft to him.",
    lines: [
      { zh: "（点了点头，把刨好的木料码得更整齐了一点。）", en: "(He nods, and squares the planed timber a little straighter.)" },
      { zh: "水坝和代码库一样：漏的地方，水自己会告诉你。", en: "Dams are like codebases: the leaks announce themselves." },
    ],
  },
];

/** farm plot: tilled grid where crops (=tasks) grow */
export const FARM = { x: 6, y: 35, w: 12, h: 6 };

/** plaza center for camera start */
export const PLAZA = { tx: 31, ty: 19 };
