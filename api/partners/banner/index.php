<?php 
    // Load database connection from start.php file
    require_once("../../start.php");
    // Load response assistant script
    require_once("../../response.php");
?>
<?php

    // Make query to the database
    // Select first the one that will end sonner
    $query_getContent = "SELECT company, bannerImage, bannerUrl
        FROM partners 
        WHERE bannerUntil>CURRENT_TIMESTAMP 
            AND bannerImage IS NOT NULL
            AND bannerURL IS NOT NULL
        ORDER BY bannerUntil ASC LIMIT 1";

    try{
        $st = $conn->prepare($query_getContent);
        // Return response
        response($st);
    } catch(Exception $e){
        errorResponse('Ocorreu um erro inesperado.', 500, $e);
    }

    // The connection is closed automatically when the script ends
?>