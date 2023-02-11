from fastapi import WebSocket, APIRouter, WebSocketDisconnect
from typing import Dict, List   
from enum import Enum
import json

router = APIRouter()


class ConnectionType(Enum):
    GENERAL = 0
    LIVE_GAME = 1

class ConnectionManager:
    def __init__(self):
        self.active_connections: Dict[ConnectionType , List[WebSocket]] = {}


    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        # check if websocket is already in active connections
        for key in self.active_connections:
            if websocket in self.active_connections[key]:
                return
        
        self.active_connections[ConnectionType.GENERAL].append(websocket)


    def disconnect(self, websocket: WebSocket):
        # wait for 5 seconds to see if user is changing page ???
        for key in self.active_connections:
            if websocket in self.active_connections[key]:
                self.active_connections[key].remove(websocket)
                break


    async def send_personal_message(self, message: str, websocket: WebSocket):
        await websocket.send_text(message)


    async def broadcast(self, connection_type, message: str):
        for websocket in self.active_connections[ConnectionType[connection_type]]:
            await websocket.send_text(message)


    async def change_connection_type(self, websocket: WebSocket, new_type: ConnectionType):
        for key in self.active_connections:
            if websocket in self.active_connections[key]:
                self.active_connections[key].remove(websocket)
                self.active_connections[new_type].append(websocket)
                break
            
manager = ConnectionManager()

"""
Message format examples:
{
    "connection_type": "GENERAL",
    "message_type": "change_connection_type",
    "message": "LIVE_GAME"
}

{
    "connection_type": "LIVE_GAME",
    "message_type": "broadcast",
    "message": JSON with game data
}
"""

@router.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await manager.connect(websocket)
    try:
        while True:
            data = await websocket.receive_text()
            data = json.load(data)
            match data["message_type"]:
                case "change_connection_type":
                    manager.change_connection_type(websocket, data["message"])
                case "broadcast":
                    await manager.broadcast(data["connection_type"],data["message"])
                    if data["connection_type"] == "LIVE_GAME":
                        ...
                        # update game data in database

    except WebSocketDisconnect:
        manager.disconnect(websocket)
