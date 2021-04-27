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

    // Get team
    $query_getContent = "SELECT users.name, linkedIn, header, mandato, team_roles.name AS role FROM team INNER JOIN users ON team.user_id=users.id INNER JOIN team_roles ON team.`role`=team_roles.id WHERE mandato=:mandate ORDER BY team_roles.weight DESC, team_roles.name, users.name";
    // Get colaborators
    $query_getContent2 = "SELECT DISTINCT users.name FROM team_colaborators INNER JOIN users ON team_colaborators.colaborator=users.id WHERE mandate=:mandate ORDER BY users.name";

    try{
        // Query 1
        $st = $conn->prepare($query_getContent);
        $st->bindParam(':mandate', $mandate);
        // Query 2
        $st2 = $conn->prepare($query_getContent2);
        $st2->bindParam(':mandate', $mandate);
        // Execute query
        $st->execute();
        $st2->execute();
        // Return response
        // Build JSON Response
        $res = $st->fetchAll(PDO::FETCH_ASSOC);
        $res2 = $st2->fetchAll(PDO::FETCH_ASSOC);
        // Return objects
        $object = (object) ['data' => (object) ['team' => $res, 'colaborators' => $res2]];
        echo json_encode($object);
    } catch(Exception $e){
        errorResponse('Ocorreu um erro inesperado.', 500, $e);
    }

    // The connection is closed automatically when the script ends
?>