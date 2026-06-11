# D 盘维护巡检报告 — 2026-06-11

随 xinlu-valley v3 重构进行的一次全盘审查与维护。`D:\Research` 全程零写入。

## 巡检范围与结论

| 根目录 | 状态 | 本次动作 |
| --- | --- | --- |
| `D:\Game_develop` | **已退役** | ai-town 迁出至 `D:\Company\xinlu-valley`；空壳目录受保护钩子拦截无法删除，留空（无害） |
| `D:\Company` | 活跃（6 项目） | 新增 xinlu-valley；launch.json 注册 xinlu-web 预览 |
| `D:\devtools` | 核心基础设施 | agentmemory 修复+加固（详见下）；`ai-town.cmd` 启动器更新到新路径 |
| `D:\AGENT_RESOURCE` | 核心资产 | workstation-maintenance SKILL.md 的根目录清单更新（Game_develop 退役注记） |
| `D:\Research` | 科研圣域 | **零修改**；游戏桥只读目录名+时间戳 |
| `D:\AGENTIC_SCIENCE` | 框架库（UUPF/LWWF/URWF） | 未动 |
| `D:\Idea` / `D:\Project` / `D:\CS project` / `D:\Healthcare` | 陈旧 | 未动；建议日后经 workstation-maintenance 流程归档 |
| `D:\frontend` / `D:\tuelearning` / `D:\UNDERGRADUATE_PROJECT_NETHERLANDS` | 陈旧档案 | 未动；同上建议 |
| `D:\_Organized` + 23 个 junction | 组织层正常 | 未动（关键 junction agent-resources / devtools-public 验证完好） |
| `D:\WEIPING_YAN_PORTFOLIO` | 活跃 | 未动 |

## agentmemory 事故修复（2026-06-10 全线 404）

- **根因**：`iii-config.yaml` 的 exec worker 用相对路径（`node dist/index.mjs`、
  `watch: src/**/*.ts`），而服务启动脚本把 cwd 锁在 `D:\devtools`（那是修数据
  漂移的对策）→ watcher 报路径不存在 → node 应用层从未启动 → 端口活着但所有
  路由 404。06-01 的 npm 升级会把 config 重置回相对路径；旧自愈只看端口监听，
  对"端口活/应用死"盲视，故障挂了一天半无人修。
- **修复**：① config exec/watch 绝对路径化（watch 指向 dist/index.mjs，升级后
  自动重载）；② 利用引擎 config 热重载特性原地复活应用层（未杀任何进程）；
  ③ `agentmemory-selfheal.ps1` v2：补 exec/watch 重打、健康探测失败时触碰
  config 强制热重载、最后手段整组重启、等待 20-25s；④ `agentmemory-health-daily.ps1`
  从"只告警"升级为"检测→自愈→复检"。
- **验证**：`/agentmemory/health` 200；53 个 MCP 工具在线；中文 UTF-8 存取无损；
  `memory_heal` 清理 5 个过期 lease；signals 通道收发往返验证通过。
- **未竟项**：15 分钟级 watchdog 计划任务被权限分类器拦截（未授权持久化）。
  如需启用，手动执行：
  `schtasks /Create /TN "AgentmemorySelfhealWatchdog" /TR "powershell.exe -NoProfile -ExecutionPolicy Bypass -File D:\devtools\agentmemory-selfheal.ps1" /SC MINUTE /MO 15 /F`

## 多 agent 协作"需重试"问题

两层根因，两层修复：

1. **agentmemory 层**（上节）：HTTP 层死亡 + 过期 lease 卡住 action 认领。
2. **游戏后端任务队列层**（`backend/main.py`）：
   - 幂等去重：相同 kind+label 的进行中任务复用，杜绝重复提交风暴；
   - 有界重试：3 次尝试 + 1.5s/4s 指数退避，事件留痕（任务均为只读/项目内写，重试安全）；
   - 工作线程 2 → 4。

## 发现的小问题（建议）

- `D:\devtools\logs\agentmemory.err.log` 恒为 0 字节——node 子进程的 stderr 由
  引擎吞掉；如需深挖，可在 server.ps1 增加单独的 node 重定向。
- agentmemory 旧数据中 321/440 条记忆缺 project 归属；系统自带回填对模糊记录
  拒绝猜测（正确行为）。新记忆按协议必带 project，会自然收敛。
- Vercel 上有一个误建的空项目 `dist`（部署脚本踩坑产物，已写防复发脚本
  `tools/deploy-web.cmd`）；可在 vercel.com 控制台一键删除。
