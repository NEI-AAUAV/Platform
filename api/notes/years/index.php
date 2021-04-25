<?php 
    // Load database connection from start.php file
    require_once("../../start.php");
    // Load response assistant script
    require_once("../../response.php");
?>
<?php

    // Make query to the database
    $query_getContent = "SELECT DISTINCT notes_schoolyear.id, notes_schoolyear.yearBegin, notes_schoolyear.yearEnd FROM notes INNER JOIN notes_schoolyear ON notes.schoolYear = notes_schoolyear.id ORDER BY notes_schoolyear.yearBegin, notes_schoolyear.yearEnd";

    try{
        $st = $conn->prepare($query_getContent);
        // Return response
        response($st);
    } catch(Exception $e){
        errorResponse('Ocorreu um erro inesperado.', 500, $e);
    }

    // The connection is closed automatically when the script ends
?>