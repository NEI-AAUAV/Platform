<?php 
    // Load database connection from credentials.php file
    require_once("../credentials.php")
?>
<?php
    
    // Get url parameter and validate it 
    $category = $_GET["category"];
    $article = $_GET["article"];

    // Prevent filtering by both parameters
    if (!empty($category) and !empty($article)) {
        $object = (object) ['error' => 'Não é possível filtrar por mais do que um parâmetro!'];
        $myJSON = json_encode($object);
        echo $myJSON;
        http_response_code(400);
        exit();
    }

    // Category filtering
    if(!empty($category)) {
        $validOptions = $conn->query("SELECT DISTINCT category FROM news WHERE status='1'")->fetchAll(PDO::FETCH_ASSOC);
        $valid = false;
        foreach($validOptions as $op) {
            if ($op['category']==$category) {
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
    }

    // Get news list (with or without category filtering)
    $query_getContent = "SELECT id, title, header, category, created_at FROM `news` WHERE status='1'";

    if(empty(!$category)) {
        $query_getContent.=" AND category=:category";    
    }

    $query_getContent.= " ORDER BY created_at DESC";

    // Get article by ID 
    if(!empty($article)) {
        $query_getContent = "SELECT title, header, content, category, created_at, last_change_at FROM `news` WHERE id=:id";
    }

    // Make query to database
    try{
        $st = $conn->prepare($query_getContent);
        if(empty(!$category)) {
            $st->bindParam(':category', $category);
        }
        if(!empty($article)) {
            $st->bindParam(':id', $article);
        }
        $st->execute();
        if($st->rowCount() > 0){
            $res = $st->fetchAll(PDO::FETCH_ASSOC);
            if(!empty($article)) {
                $object = (object) ['data' => $res[0]];
            } else {
                $object = (object) ['data' => $res];
            }
            $myJSON = json_encode($object);
            echo $myJSON;
        } else {
            $object = (object) ['data' => []];
            $myJSON = json_encode($object);
            echo $myJSON;
        }
    } catch(Exception $e){
        $object = (object) ['error' => 'Ocorreu um erro inesperado.', 'description' => $e->getMessage()];
        $myJSON = json_encode($object);
        echo $myJSON;
        http_response_code(500);
        exit();
    }

    // The connection is closed automatically when the script ends
?>