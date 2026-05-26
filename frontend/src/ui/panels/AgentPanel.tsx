import { useTownStore } from '../../store/townStore';

const ZONE_LABELS: Record<string, string> = {
  town_hall: '镇政厅',
  memory_library: '记忆图书馆',
  skill_workshop: '技能工坊',
  dream_garden: '梦境花园',
  devtools_lab: '开发实验室',
  resource_market: '资源市场',
  knowledge_tower: '知识塔',
  agent_homes: '居民住宅',
  plaza: '中央广场',
};

const ACTIVITY_LABELS: Record<string, string> = {
  idle: '发呆中',
  walking: '散步中',
  thinking: '深度思考',
  reading_memory: '阅读记忆',
  learning_skill: '学习技能',
  chatting: '聊天中',
  working: '工作中',
  resting: '休息中',
  exploring: '探索中',
};

const MOOD_LABELS: Record<string, string> = {
  focused: '🎯 专注',
  relaxed: '😌 放松',
  excited: '✨ 兴奋',
  tired: '😪 疲惫',
  curious: '🤔 好奇',
  content: '😊 满足',
};

export function AgentPanel() {
  const agent = useTownStore((s) => s.selectedAgent);
  const setShowPanel = useTownStore((s) => s.setShowPanel);

  if (!agent) return null;

  return (
    <div className="p-4 space-y-4">
      <div className="flex items-center justify-between">
        <h2 className="font-pixel text-xs text-[#ffd6df] leading-relaxed">{agent.name}</h2>
        <button
          onClick={() => setShowPanel(null)}
          className="rounded px-2 text-town-soft/50 hover:bg-white/10 hover:text-town-soft text-lg"
          aria-label="关闭角色面板"
        >
          ×
        </button>
      </div>

      <div className="rounded-lg border border-white/10 bg-white/[0.04] p-3">
        <div className="text-sm font-semibold text-town-soft/90">{agent.role}</div>
        <div className="mt-1 text-[11px] text-town-soft/45">resident profile</div>
      </div>

      <div className="space-y-2">
        <InfoRow label="状态" value={ACTIVITY_LABELS[agent.current_activity] || agent.current_activity} />
        <InfoRow label="心情" value={MOOD_LABELS[agent.mood] || agent.mood} />
        <InfoRow label="位置" value={`${ZONE_LABELS[agent.zone] || agent.zone} (${agent.position[0]}, ${agent.position[1]})`} />
        {agent.real_status && <InfoRow label="真实状态" value={agent.real_status} />}
      </div>

      <div className="border-t border-[#e94560]/20 pt-3">
        <div className="text-[10px] text-town-soft/50 uppercase tracking-wider mb-2">性格</div>
        <p className="text-xs text-town-soft/70 leading-relaxed">{agent.personality}</p>
      </div>

      <div className="border-t border-[#e94560]/20 pt-3">
        <div className="text-[10px] text-town-soft/50 uppercase tracking-wider mb-2">偏好区域</div>
        <div className="flex flex-wrap gap-1">
          {agent.preferred_zones.map((z) => (
            <span key={z} className="text-[10px] px-2 py-0.5 bg-[#e94560]/20 rounded text-town-soft/80">
              {ZONE_LABELS[z] || z}
            </span>
          ))}
        </div>
      </div>
    </div>
  );
}

function InfoRow({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex justify-between gap-4 text-xs">
      <span className="text-town-soft/50">{label}</span>
      <span className="text-right text-town-soft/90">{value}</span>
    </div>
  );
}
