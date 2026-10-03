import { useEffect } from "react";
import { getSocket } from "services/SocketService";

const ws = getSocket();

export function Component() {
    // var ws = new WebSocket(config.WS_URL);
    // ws.onmessage = function (event) {

    //     //
    //     console.log(event.data);
    // };
    useEffect(() => {
        Promise.resolve(ws.getLiveGames()).catch((error) => {
            console.error("Failed to get live games:", error);
        });
    }, [])

    return (<div>olá</div>);
}
