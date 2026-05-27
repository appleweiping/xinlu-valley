import { useState } from 'react'
import { useGameStore } from '../store/gameStore'

interface Props {
  agentId: string
}

export function DialoguePanel({ agentId }: Props) {
  const [input, setInput] = useState('')
  const [loading, setLoading] = useState(false)
  const agents = useGameStore(s => s.agents)
  const history = useGameStore(s => s.dialogueHistory)
  const addDialogue = useGameStore(s => s.addDialogue)
  const selectAgent = useGameStore(s => s.selectAgent)

  const agent = agents.find(a => a.id === agentId)
  if (!agent) return null

  const sendMessage = async () => {
    if (!input.trim() || loading) return
    const msg = input.trim()
    setInput('')
    addDialogue({ role: 'player', content: msg })
    setLoading(true)

    try {
      const res = await fetch('http://localhost:8000/api/dialogue', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ agent_id: agentId, message: msg }),
      })
      const data = await res.json()
      addDialogue({ role: 'agent', content: data.response })
    } catch {
      addDialogue({ role: 'agent', content: '*yawns* ...the connection seems unstable. Try again?' })
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="dialogue-panel">
      <div className="dialogue-header">
        <span className="agent-name">{agent.name}</span>
        <span className="agent-role">{agent.role}</span>
        <button className="close-btn" onClick={() => selectAgent(null)}>×</button>
      </div>
      <div className="dialogue-history">
        {history.length === 0 && (
          <div className="dialogue-hint">Click to start a conversation with {agent.name.split(' ')[0]}...</div>
        )}
        {history.map((msg, i) => (
          <div key={i} className={`dialogue-msg ${msg.role}`}>
            <span className="msg-sender">{msg.role === 'player' ? 'You' : agent.name.split(' ')[0]}</span>
            <span className="msg-content">{msg.content}</span>
          </div>
        ))}
        {loading && <div className="dialogue-msg agent typing">...</div>}
      </div>
      <div className="dialogue-input">
        <input
          type="text"
          value={input}
          onChange={e => setInput(e.target.value)}
          onKeyDown={e => e.key === 'Enter' && sendMessage()}
          placeholder="Say something..."
          disabled={loading}
        />
        <button onClick={sendMessage} disabled={loading || !input.trim()}>Send</button>
      </div>
    </div>
  )
}
