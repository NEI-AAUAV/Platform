
const WebSocketTest = () => {
    var ws = new WebSocket("ws://localhost:8000/api/nei/v1/ws/ws");
    ws.onmessage = function (event) {
        
        //
        console.log(event.data);
    };
    return (<div>olá</div>);
}

export default WebSocketTest;    