<?php 
    // Load database connection from start.php file
    require_once("../start.php");
    // Load response assistant script
    require_once("../response.php");
?>
<?php
    
    // Get url parameter and validate it 
    $mandate = $_GET["mandate"];
    $validOptions = $conn->query("SELECT DISTINCT mandato FROM team")->fetchAll(PDO::FETCH_ASSOC);
    $valid = false;
    foreach($validOptions as $op) {
        if ($op['mandato']==$mandate) {
            $valid = true;
        }
    }
    if(!$valid and is_null($_GET["mandate"])) {
        errorResponse('Parâmetro "mandate" em falta!');
    } else if (!$valid) {
        errorResponse('Parâmetro "mandate" inválido!');
    }

    // Make query to the database
    $query_getContent = "SELECT name, linkedIn, header, title, mandato FROM team INNER JOIN users ON team.user_id=users.id WHERE mandato=:mandate";

    try{
        $st = $conn->prepare($query_getContent);
        // Bind parameters to query
        $st->bindParam(':mandate', $mandate);
        // Return response
        response($st);
    } catch(Exception $e){
        errorResponse('Ocorreu um erro inesperado.', 500, $e);
    }

    // The connection is closed automatically when the script ends
?>