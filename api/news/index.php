<?php 
    // Load database connection from start.php file
    require_once("../start.php");
    // Load response assistant script
    require_once("../response.php");
    // Load pagination assistant script
    require_once("../pagination.php");
?>
<?php

    // Get url parameter and validate it 
    $category = $_GET["category"];
    $article = $_GET["article"];

    // Pagination
    list($page_number, $page_size) = validatePagination(
        $page_number, 
        $page_size, 
        !empty($article) ? ['article'] : []
    );

    // Prevent filtering by both parameters
    if (!empty($category) and !empty($article)) {
        errorResponse('Não é possível filtrar por mais do que um parâmetro!');
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
            errorResponse('Categoria inválida!');
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
            // Return response
            response($st);
        }
        // Return paginated results
        paginate($st, $page_number, $page_size);
    } catch(Exception $e){
        errorResponse('Ocorreu um erro inesperado.', 500);
    }

    // The connection is closed automatically when the script ends
?>