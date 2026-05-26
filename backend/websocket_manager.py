from fastapi import WebSocket
from typing import Set
import json


class WebSocketManager:
    def __init__(self):
        self.connections: Set[WebSocket] = set()

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.connections.add(websocket)

    def disconnect(self, websocket: WebSocket):
        self.connections.discard(websocket)

    async def broadcast(self, data: dict):
        dead = set()
        message = json.dumps(data, ensure_ascii=False)
        for ws in self.connections:
            try:
                await ws.send_text(message)
            except Exception:
                dead.add(ws)
        self.connections -= dead

    @property
    def client_count(self) -> int:
        return len(self.connections)
