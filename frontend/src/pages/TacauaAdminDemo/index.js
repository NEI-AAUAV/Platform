
const TacaUaAdminDemo = () => {
    var ws = new WebSocket("ws://localhost:8000/nei/api/v1/ws/ws");

    function sendMessage() {
        ws.send(document.getElementById("fname").value);
    }
    ws.onmessage = function (event) {
        console.log(event.data);
    };

    return (<div> <input type="text" id="fname" name="fname"/> <button onClick={sendMessage}>TESTING</button></div>);
}

export default TacaUaAdminDemo;