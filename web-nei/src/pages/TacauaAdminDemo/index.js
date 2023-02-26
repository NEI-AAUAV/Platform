import config from "config";
const TacaUaAdminDemo = () => {
    var ws = new WebSocket("ws://localhost/api/nei/v1/ws");
    console.log(ws)

    function sendMessage() {
        ws.send(JSON.stringify({ topic: "LIVE_GAME", value: document.getElementById("fname").value }));
    }
    ws.onmessage = function (event) {
        console.log(event.data);
    };

    return (<div> <input type="text" id="fname" name="fname" /> <button onClick={sendMessage}>TESTING</button></div>);
}

export default TacaUaAdminDemo;