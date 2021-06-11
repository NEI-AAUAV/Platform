<?php 
    // Load database connection from start.php file
    require_once("../start.php");
    // Load response assistant script
    require_once("../response.php");
?>
<?php

    // Make query to the database
    $query_getContent = "SELECT name, image, price FROM `merchandisings` ORDER BY name";

    try{
        $st = $conn->prepare($query_getContent);
        // Return response
        response($st);
    } catch(Exception $e){
        errorResponse('Ocorreu um erro inesperado.', 500, $e);
    }

    // The connection is closed automatically when the script ends
?>