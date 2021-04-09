<?php 
    // Load database connection from credentials.php file
    require_once("../credentials.php")
?>
<?php
    
    // Get url parameter and validate it 
    $par = $_GET["categoria"];
    $validOptions = $conn->query("SELECT DISTINCT categoria FROM rgm")->fetchAll(PDO::FETCH_ASSOC);
    $valid = false;
    foreach($validOptions as $op) {
        if ($op['categoria']==$par) {
            $valid = true;
        }
    }
    if(!$valid) {
        $object = (object) ['error' => 'Parâmetro inválido!'];
        $myJSON = json_encode($object);
        echo $myJSON;
        http_response_code(400);
        exit();
    }

    // Make query to the database
    $query_getContent = "SELECT mandato, file FROM `rgm` WHERE categoria=:categoria ORDER BY file";

    try{
        $st = $conn->prepare($query_getContent);
        $st->execute([':categoria' => $_GET["categoria"]]);
        if($st->rowCount() > 0){
            $res = $st->fetchAll(PDO::FETCH_ASSOC);
            $object = (object) ['data' => $res];
            $myJSON = json_encode($object);
            echo $myJSON;
        } else {
            $object = (object) ['data' => []];
            $myJSON = json_encode($object);
            echo $myJSON;
        }
    } catch(Exception $e){
        $object = (object) ['error' => 'Ocorreu um erro inesperado.'];
        $myJSON = json_encode($object);
        echo $myJSON;
        http_response_code(500);
        exit();
    }

    // The connection is closed automatically when the script ends
?>