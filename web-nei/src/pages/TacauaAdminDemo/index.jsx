import { getSocket, wsend } from "services/SocketService";

const ws = getSocket();

function sendMessage() {
    wsend({ topic: "LIVE_GAME", value: document.getElementById("fname").value }).catch((error) => {
        console.error("Failed to send message", error);
    });
}

export function Component() {
    return (<div> <input type="text" id="fname" name="fname" /> <button onClick={sendMessage}>TESTING</button></div>);
}
