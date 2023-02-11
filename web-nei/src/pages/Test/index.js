import config from "config";
const WebSocketTest = () => {
    var ws = new WebSocket(config.WS_URL);
    ws.onmessage = function (event) {
        
        //
        console.log(event.data);
    };
    return (<div>olá</div>);
}

export default WebSocketTest;    