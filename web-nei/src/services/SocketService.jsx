import config from "config";
import {useSocketStore} from "stores/useSocketStore";

let socket;

export const getSocket = () => {
    // Send message methods
    const getLiveGames = async () => {
        const payload = {
            topic: "LIVE_GAME",
        }
        await wsend(payload);
    }

    if (!socket) {
        socket = new WebSocket(`${config.WS_URL}/ws`);
        // console.log(socket)

        socket.onopen = async (event) => {
            console.info("[open] Connection established");
        };

        socket.onmessage = (event) => {
            var data = JSON.parse(event.data);
            // Receive messages
            switch (data.topic) {
                case "LIVE_GAMES":
                    useSocketStore.getState().setGame(data.game);
                    break;
                }
        }

        socket.onclose = (event) => {
            console.info(`[close] Connection died, code=${event.code} reason=${event.reason}`);
            socket = null;
        }

        socket.onerror = (error) => {
            console.error(`[error] ${error.message}`);
        }
    }

    return { socket, getLiveGames };
}

export const wsend = async (d) => {
    if (socket && socket.readyState === socket.OPEN) {
        await socket.send(JSON.stringify(d));
    } else {
        console.error("could not send ", d)
    }
}

export const getArraialSocket = () => {
    const ws = new WebSocket(`${config.WS_URL}/arraial/ws`);
    return ws;
}
