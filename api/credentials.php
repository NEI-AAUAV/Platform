<?php

    $servername = "mysql-hosting.ua.pt";
    $username = "aauav-nei-web";
    $password = "@VsmlVJT^ajtKH3x$4Nx&F2R%MB%nakmBFdyWvm3QOFZXYtPUSngozy^XpY!gjjZ9!M&S3yG3D5CXNgYCBey*BhR4t38^W@Qy";

    // Connect to database
    try{
        // Create connection
        $conn = new PDO("mysql:host=$servername;dbname=aauav-nei;charset=utf8",$username, $password);
        // Set the PDO error mode to exception
        // This captures errors and saves them to log file instead of printing them on the screen
        $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        // Return associative aray as default
        // $conn->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
    } catch (PDOException $e){
        $object = (object) ['error' => 'Ocorreu um erro na conexão à base de dados.'];
        $myJSON = json_encode($object);
        echo $myJSON;
        http_response_code(500);
        exit();
    }

?>