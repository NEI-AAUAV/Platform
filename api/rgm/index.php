<?php 
    // Load database connection from start.php file
    require_once("../start.php");
    // Load response assistant script
    require_once("../response.php");
?>
<?php
    
    // Get url parameter and validate it 
    $category = $_GET["category"];
    $validOptions = $conn->query("SELECT DISTINCT categoria FROM rgm")->fetchAll(PDO::FETCH_ASSOC);
    $valid = false;
    foreach($validOptions as $op) {
        if ($op['categoria']==$category) {
            $valid = true;
        }
    }
    if(!$valid) {
        errorResponse('Parâmetro inválido!');
    }

    // Make query to the database
    $query_getContent = "SELECT mandato, file FROM `rgm` WHERE categoria=:categoria ORDER BY file";

    try{
        $st = $conn->prepare($query_getContent);
        // Bind parameters to query
        $st->bindParam(':categoria', $category);
        // Return response
        response($st);
    } catch(Exception $e){
        errorResponse('Ocorreu um erro inesperado.', 500);
    }

    // The connection is closed automatically when the script ends
?>