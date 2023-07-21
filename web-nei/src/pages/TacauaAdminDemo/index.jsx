import config from "config";
import { getSocket, wsend } from "services/SocketService";

const ws = getSocket();

export function Component() {

    function sendMessage() {
        wsend({ topic: "LIVE_GAME", value: document.getElementById("fname").value });
    }

    return (<div> <input type="text" id="fname" name="fname" /> <button onClick={sendMessage}>TESTING</button></div>);
}
