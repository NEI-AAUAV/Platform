<?php 
    // Load database connection from start.php file
    require_once("../../../start.php");
    // Load response assistant script
    require_once("../../../response.php");
?>
<?php
    
    // Get url parameter and validate it 
    $course = $_GET["course"];
    $validOptions = $conn->query("SELECT DISTINCT course FROM seniors")->fetchAll(PDO::FETCH_ASSOC);
    $valid = false;
    foreach($validOptions as $op) {
        if ($op['course']==$course) {
            $valid = true;
        }
    }
    if(!$valid and is_null($_GET["course"])) {
        errorResponse('Parâmetro "course" em falta!');
    } else if (!$valid) {
        errorResponse('Parâmetro "course" inválido!');
    }

    // Make query to the database
    $query_getContent = "SELECT DISTINCT year FROM seniors WHERE course=:courseVar ORDER BY year";

    try{
        $st = $conn->prepare($query_getContent);
        // Bind parameters to query
        $st->bindParam(':courseVar', $course);
        // Return response
        response($st);
    } catch(Exception $e){
        errorResponse('Ocorreu um erro inesperado.', 500, $e);
    }

    // The connection is closed automatically when the script ends
?>