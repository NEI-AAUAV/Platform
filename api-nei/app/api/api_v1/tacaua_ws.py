from fastapi import Body, WebSocket, APIRouter, WebSocketDisconnect
from typing import Any, Dict, List   
from enum import Enum
import json
from loguru import logger
from pytest import Session

router = APIRouter()

class ConnectionType(Enum):
    GENERAL = 0

class ConnectionManager:
    def __init__(self):
        self.active_connections: Dict[ConnectionType , List[WebSocket]] = {ConnectionType.GENERAL: []}


    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        # check if websocket is already in active connections
        for key in self.active_connections:
            if websocket in self.active_connections[key]:
                return
        logger.info("New connection")
        logger.info(self.active_connections)
        self.active_connections[ConnectionType.GENERAL].append(websocket)


    def disconnect(self, websocket: WebSocket):
        # wait for 5 seconds to see if user is changing page ???
        for key in self.active_connections:
            if websocket in self.active_connections[key]:
                self.active_connections[key].remove(websocket)
                break


    async def send_personal_message(self, message: str, websocket: WebSocket):
        await websocket.send_text(message)


    async def broadcast(self, connection_type: ConnectionType, message: dict):
        for websocket in self.active_connections[connection_type]:
            await websocket.send_json(message)


    async def change_connection_type(self, websocket: WebSocket, new_type: ConnectionType):
        for key in self.active_connections:
            if websocket in self.active_connections[key]:
                self.active_connections[key].remove(websocket)
                self.active_connections[new_type].append(websocket)
                break
            
manager = ConnectionManager()

"""
Message format examples:
Receive
{
    "topic": "GET_LIVE_GAMES",
}
Send
{
    "topic": "GET_LIVE_GAMES",
    "games": JSON with live games data
}

Receive 
HTTP POST /ws/broadcast {
    "topic": "UPDATE_LIVE_GAME",
    "game": JSON with live game data
}
Send
{
    "topic": "UPDATE_LIVE_GAME",
    "game": JSON with live game data
}
"""

@router.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await manager.connect(websocket)
    try:
        while True:
            data = await websocket.receive_json()
            logger.info(data)
            match data["topic"]:
                case "LIVE_GAME":
                    logger.info("LIVE_GAME", data)
                    data = {"topic": "LIVE_GAMES", "game": {"id": 1, "team1": 'NEI', "team2": "NEEET"}}
                    await manager.broadcast(connection_type=ConnectionType.GENERAL, message=data)

    except WebSocketDisconnect:
        manager.disconnect(websocket)


@router.post("/ws/broadcast", status_code=200)
async def websocket_broadcast(*, data_in: dict = Body()):
    logger.info(data_in)
    await manager.broadcast(connection_type=ConnectionType.GENERAL, message=data_in)
    return {"status": "success", "message": "All websockets were notified."}
   