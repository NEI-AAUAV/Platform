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
    $video = $_GET["video"];

    // Pagination
    list($page_number, $page_size) = validatePagination(
        $page_number, 
        $page_size, 
        !empty($video) ? ['video'] : []
    );

    // Prevent filtering by both parameters
    if (count($categories)>0 and !empty($video)) {
        errorResponse('Não é possível filtrar com o argumento "video"!');
    }

    // Parameter validation
    if(count($categories)>0) {
        $validOptions = $conn->query("SELECT id FROM videos_tags")->fetchAll(PDO::FETCH_ASSOC);
        $valid = true;
        foreach($categories as $category) {
            $validCat = false;
            foreach($validOptions as $op) {
                if ($op['id']==$category) {
                    $validCat = true;
                }
            }
            $valid = $valid && $validCat;
        }
        if(!$valid) {
            errorResponse('Categoria inválida!');
        }
    }

    // Get videos list (with or without category filtering)
    $query_getContent = "SELECT id, tag, name, image, created FROM videos WHERE 1";

    if(count($categories)>0) {
        $query_getContent.=" AND (";
        $counter = 0;
        foreach($categories as $category) {
            $query_getContent.=" tag=:category{$counter}";
            $counter = $counter + 1;
            if($counter < count($categories)) {
                $query_getContent.=" OR";
            }    
        }
        $query_getContent.=")";
    }

    $query_getContent.= " ORDER BY created DESC, name DESC";

    // Get video by ID 
    if(!empty($video)) {
        $query_getContent = "SELECT id, tag, name, image, created, ytId FROM videos WHERE id=:id";
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
        if(!empty($video)) {
            $st->bindParam(':id', $video);
            // Return response
            response($st, true);
        }
        // Return paginated results
        paginate($st, $page_number, $page_size);
    } catch(Exception $e){
        errorResponse('Ocorreu um erro inesperado.', 500, $e);
    }

    // The connection is closed automatically when the script ends
?>