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
    if(!$valid and empty($_GET["mandate"])) {
        errorResponse('Parâmetro "mandate" em falta!');
    } else if (!$valid) {
        errorResponse('Parâmetro "mandate" inválido!');
    }

    // Make query to the database
    $query_getContent = "SELECT users.name, linkedIn, header, mandato, team_roles.name AS role FROM team INNER JOIN users ON team.user_id=users.id INNER JOIN team_roles ON team.`role`=team_roles.id WHERE mandato=:mandate ORDER BY team_roles.weight DESC, team_roles.name, users.name";

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