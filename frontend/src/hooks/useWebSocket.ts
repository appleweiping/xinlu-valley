import { useEffect, useRef } from 'react';
import { useTownStore } from '../store/townStore';
import type { TownState } from '../types';

export function useWebSocket() {
  const wsRef = useRef<WebSocket | null>(null);
  const setState = useTownStore((s) => s.setState);
  const setConnected = useTownStore((s) => s.setConnected);

  useEffect(() => {
    let reconnectTimer: number | undefined;
    let cancelled = false;

    function connect() {
      if (cancelled) return;
      const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
      const wsUrl = import.meta.env.VITE_WS_URL ?? `${protocol}//${window.location.host}/ws`;
      const ws = new WebSocket(wsUrl);
      wsRef.current = ws;

      ws.onopen = () => {
        if (cancelled) return;
        setConnected(true);
      };

      ws.onmessage = (event) => {
        try {
          const data = JSON.parse(event.data);
          if (data.type === 'init' || data.type === 'tick') {
            setState(data.state as TownState);
          }
        } catch (e) {
          console.warn('[ws] parse error:', e);
        }
      };

      ws.onclose = () => {
        if (cancelled) return;
        setConnected(false);
        reconnectTimer = window.setTimeout(connect, 3000);
      };

      ws.onerror = () => {
        ws.close();
      };
    }

    connect();

    const pingInterval = setInterval(() => {
      if (wsRef.current?.readyState === WebSocket.OPEN) {
        wsRef.current.send('ping');
      }
    }, 30000);

    return () => {
      cancelled = true;
      clearInterval(pingInterval);
      if (reconnectTimer) clearTimeout(reconnectTimer);
      wsRef.current?.close();
      wsRef.current = null;
    };
  }, [setState, setConnected]);
}
