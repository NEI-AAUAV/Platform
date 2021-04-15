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
    $categories = $_GET["category"]!=NULL ? $_GET["category"] : [];
    $article = $_GET["article"];

    // Pagination
    list($page_number, $page_size) = validatePagination(
        $page_number, 
        $page_size, 
        !empty($article) ? ['article'] : []
    );

    // Prevent filtering by both parameters
    if (count($categories)>0 and !empty($article)) {
        errorResponse('Não é possível filtrar por mais do que um parâmetro!');
    }

    // Category filtering
    if(count($categories)>0) {
        $validOptions = $conn->query("SELECT DISTINCT category FROM news WHERE status='1'")->fetchAll(PDO::FETCH_ASSOC);
        $valid = true;
        foreach($categories as $category) {
            $validCat = false;
            foreach($validOptions as $op) {
                if ($op['category']==$category) {
                    $validCat = true;
                }
            }
            $valid = $valid && $validCat;
        }
        if(!$valid) {
            errorResponse('Categoria inválida!');
        }
    }

    // Get news list (with or without category filtering)
    $query_getContent = "SELECT id, title, header, category, created_at FROM `news` WHERE status='1'";

    if(count($categories)>0) {
        $query_getContent.=" AND";    
        $counter = 0;
        foreach($categories as $category) {
            $query_getContent.=" category=:category{$counter}";
            $counter = $counter + 1;
            if($counter < count($categories)) {
                $query_getContent.=" OR";
            }    
        }
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
        if(count($categories)>0) {
            $counter = 0;
            foreach($categories as $category) {
                $st->bindParam(":category{$counter}", $categories[$counter]);
                $counter = $counter + 1;    
            }
        }
        if(!empty($article)) {
            $st->bindParam(':id', $article);
            // Return response
            response($st);
        }
        // Return paginated results
        paginate($st, $page_number, $page_size);
    } catch(Exception $e){
        errorResponse('Ocorreu um erro inesperado.', 500, $e);
    }

    // The connection is closed automatically when the script ends
?>