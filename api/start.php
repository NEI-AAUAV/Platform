<?php

    /**
     * This script...
     *  - prepares HTTP request necessary headers 
     *  - starts a new database connection
     */

    // Load database credentials from credentials.php file
    require_once("credentials.php");
    // Load response assistant script
    require_once("response.php");

    // Tell browser the response is JSON encoded
    header('Content-Type: application/json');
    header('Access-Control-Allow-Origin: *');
    header("Access-Control-Allow-Methods:GET,POST");
    header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");

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
        errorResponse('Ocorreu um erro na conexão à base de dados.', 500, $e);
    }

?>