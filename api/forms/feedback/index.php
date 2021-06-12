<?php 
    // Load database connection from start.php file
    require_once("../../start.php");
    // Load response assistant script
    require_once("../../response.php");
?>
<?php

    // Function for post
    function httpPost($url, $data){
        $curl = curl_init($url);
        curl_setopt($curl, CURLOPT_POST, true);
        curl_setopt($curl, CURLOPT_HTTPHEADER, array('Content-Type: application/json')); 
        curl_setopt($curl, CURLOPT_POSTFIELDS, json_encode($data));
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        $response = curl_exec($curl);
        curl_close($curl);
        return $response;
    }

    // Get POST data
    if ($_SERVER["REQUEST_METHOD"] == "POST") {

        // Get JSON data sent
        $_POST = json_decode(file_get_contents("php://input"), true);

        // Get values
        $name = $_POST['name'];
        $email = $_POST['email'];
        $message = $_POST['message'];

        // Validate
        if (empty($name)) {
            errorResponse("Pedido inválido! Atributos em falta.", 400);
        }
        if (empty($email)) {
            errorResponse("Pedido inválido! Atributos em falta.", 400);
        }
        if (empty($message)) {
            errorResponse("Pedido inválido! Atributos em falta.", 400);
        }

        // Send notification to Slack
        $jsontext = "*New feedback*\n\nBy $name ($email)\n\nMessage below\n----------$message\n----------";
        $jsonobj = (object) ['text' => $jsontext];
        $response = httpPost(
            "https://hooks.slack.com/services/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",
            $jsonobj
        );

        if (strpos($response, 'ok') !== false) {
            successResponse("Formulário enviado com sucessi");
        }

        errorResponse("Ocorreu um erro inesperado, tenta novamente.", 500);
    } 

    errorResponse("Este endpoint só suporta pedidos POST!", 400);
    // The connection is closed automatically when the script ends
?>