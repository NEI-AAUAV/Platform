<?php 
    // Load database connection from start.php file
    require_once("../start.php");
    // Load response assistant script
    require_once("../response.php");
?>
<?php
    
    // Get url parameter and validate it 
    $alias = $_GET["alias"];
    if(empty($_GET["alias"])) {
        errorResponse('Parâmetro "alias" em falta!');
    }

    // Make query to the database
    $query_getContent = "SELECT redirect FROM `redirects` WHERE alias=:alias LIMIT 1";

    try{
        $st = $conn->prepare($query_getContent);
        // Bind parameters to query
        $st->bindParam(':alias', $alias);
        // Return response
        response($st);
    } catch(Exception $e){
        errorResponse('Ocorreu um erro inesperado.', 500, $e);
    }

    // The connection is closed automatically when the script ends
?>