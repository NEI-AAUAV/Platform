<?php 
    // Load database connection from credentials.php file
    require_once("../../credentials.php")
?>
<?php

    // Make query to the database
    $query_getContent = "SELECT DISTINCT category FROM news WHERE status='1' ORDER BY category";

    try{
        $st = $conn->prepare($query_getContent);
        $st->execute();
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