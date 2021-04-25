<?php 
    // Load database connection from start.php file
    require_once("../../start.php");
    // Load response assistant script
    require_once("../../response.php");
?>
<?php

    // Make query to the database
    $query_getContent = "SELECT DISTINCT notes_subjects.name, notes_subjects.short, notes_subjects.paco_code, notes_subjects.year, notes_subjects.semester FROM notes INNER JOIN notes_subjects ON notes.subject = notes_subjects.paco_code ORDER BY notes_subjects.year, notes_subjects.semester, notes_subjects.name";

    try{
        $st = $conn->prepare($query_getContent);
        // Return response
        response($st);
    } catch(Exception $e){
        errorResponse('Ocorreu um erro inesperado.', 500, $e);
    }

    // The connection is closed automatically when the script ends
?>