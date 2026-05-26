import { useTownStore } from '../../store/townStore';

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
        <h2 className="font-pixel text-xs text-[#e94560]">{agent.name}</h2>
        <button
          onClick={() => setShowPanel(null)}
          className="text-town-soft/50 hover:text-town-soft text-lg"
        >
          ×
        </button>
      </div>

      <div className="text-sm text-town-soft/80">{agent.role}</div>

      <div className="space-y-2">
        <InfoRow label="状态" value={ACTIVITY_LABELS[agent.current_activity] || agent.current_activity} />
        <InfoRow label="心情" value={MOOD_LABELS[agent.mood] || agent.mood} />
        <InfoRow label="位置" value={`${agent.zone} (${agent.position[0]}, ${agent.position[1]})`} />
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
              {z}
            </span>
          ))}
        </div>
      </div>
    </div>
  );
}

function InfoRow({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex justify-between text-xs">
      <span className="text-town-soft/50">{label}</span>
      <span className="text-town-soft/90">{value}</span>
    </div>
  );
}
