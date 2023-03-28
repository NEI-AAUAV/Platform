import { useEffect } from "react";
import { getSocket } from "services/SocketService";

const ws = getSocket();

const WebSocketTest = () => {
    // var ws = new WebSocket(config.WS_URL);
    // ws.onmessage = function (event) {
        
    //     //
    //     console.log(event.data);
    // };
    useEffect(() => {
        ws.getLiveGames();
    }, [])

    return (<div>olá</div>);
}

export default WebSocketTest;
