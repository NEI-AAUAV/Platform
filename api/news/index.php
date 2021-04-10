<?php 
    // Load database connection from credentials.php file
    require_once("../credentials.php")
?>
<?php
    
    // Pagination
    $page_number = empty($_GET["page"]) ? $page_number : (int)$_GET["page"];
    $page_size = empty($_GET["itemsPerPage"]) ? $page_size : (int)$_GET["itemsPerPage"];
    if($page_number<=0 || $page_size<=0) {
        $object = (object) ['error' => $page_number<=0 ? 'Página inválida!' : 'Número de items por página inválido!'];
        $myJSON = json_encode($object);
        echo $myJSON;
        http_response_code(400);
        exit();
    }

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
            $object = (object) ['error' => 'Categoria inválida!'];
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
        // Bind parameters to query
        if(empty(!$category)) {
            $st->bindParam(':category', $category);
        }
        if(!empty($article)) {
            $st->bindParam(':id', $article);
        }
        // Execute query
        $st->execute();
        // Build JSON Response
        if($st->rowCount() > 0){
            $res = $st->fetchAll(PDO::FETCH_ASSOC);
            if(!empty($article)) {
                $object = (object) ['data' => $res[0]];
            } else {
                // If news list, add pagination
                if (($page_size*($page_number-1)) > count($res)) {
                    // Validate there are that many pages
                    $object = (object) ['error' => 'Página inválida!'];
                    http_response_code(400);
                } else {
                    // If so, slice array
                    $pages_number = ceil(count($res)/$page_size);
                    $res = array_slice($res, ($page_size*($page_number-1)), $page_size);
                    $object = (object) ['page' => (object) [ 
                        'itemsPerPage' => $page_size, 
                        'currentPage' => $page_number, 
                        'count' => count($res),
                        'pagesNumber' => $pages_number,
                    ], 'data' => $res];
                }
            }
            $myJSON = json_encode($object);
            echo $myJSON;
        } else {
            if ($page_number>1) {
                // Validate there are that many pages
                $object = (object) ['error' => 'Página inválida!'];
                http_response_code(400);
            } else {
                $object = (object) ['page' => (object) [ 
                    'itemsPerPage' => $page_size, 
                    'currentPage' => $page_number, 
                    'count' => 0,
                    'pagesNumber' => 1,
                ], 'data' => []];
            }
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