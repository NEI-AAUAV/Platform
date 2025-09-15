from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from typing import Dict, List
from enum import Enum

router = APIRouter()

class ArraialConnectionType(Enum):
    GENERAL = 0

class ArraialConnectionManager:
    def __init__(self):
        self.active_connections: Dict[ArraialConnectionType, List[WebSocket]] = {
            ArraialConnectionType.GENERAL: []
        }

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        for key in self.active_connections:
            if websocket in self.active_connections[key]:
                return
        self.active_connections[ArraialConnectionType.GENERAL].append(websocket)

    def disconnect(self, websocket: WebSocket):
        for key in self.active_connections:
            if websocket in self.active_connections[key]:
                self.active_connections[key].remove(websocket)
                break

    async def broadcast(self, connection_type: ArraialConnectionType, message: dict):
        stale: List[WebSocket] = []
        for websocket in self.active_connections[connection_type]:
            try:
                await websocket.send_json(message)
            except Exception:
                stale.append(websocket)
        for ws in stale:
            self.disconnect(ws)

arraial_ws_manager = ArraialConnectionManager()

@router.websocket("/arraial/ws")
async def arraial_websocket_endpoint(websocket: WebSocket):
    await arraial_ws_manager.connect(websocket)
    try:
        while True:
            # Keep the connection open; no incoming messages expected
            await websocket.receive_text()
    except WebSocketDisconnect:
        arraial_ws_manager.disconnect(websocket)
