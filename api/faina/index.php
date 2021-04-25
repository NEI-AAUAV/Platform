<?php 
    // Load database connection from start.php file
    require_once("../start.php");
    // Load response assistant script
    require_once("../response.php");
?>
<?php
    
    // Get url parameter and validate it 
    $mandate = $_GET["mandate"];
    $validOptions = $conn->query("SELECT DISTINCT mandato FROM faina")->fetchAll(PDO::FETCH_ASSOC);
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
    $query_getContent = "SELECT imagem, mandato FROM faina WHERE mandato=:mandate";
    // Get members
    $query_getContent2 = "SELECT users.name, faina_roles.name AS role FROM faina_member INNER JOIN users ON faina_member.member=users.id INNER JOIN faina_roles ON faina_member.role=faina_roles.id WHERE year=:mandate ORDER BY faina_roles.weight DESC, users.name";

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
        // Add res2 to res
        $res[0]['members'] = $res2;
        $object = (object) ['data' => $res];
        echo json_encode($object);
    } catch(Exception $e){
        errorResponse('Ocorreu um erro inesperado.', 500, $e);
    }

    // The connection is closed automatically when the script ends
?>