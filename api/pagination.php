<?php

    // Default values
    $page_size = 9;
    $page_number = 1;

    // Parameter validation
    function validatePagination($page_number, $page_size) {
        $page_number = empty($_GET["page"]) ? $page_number : (int)$_GET["page"];
        $page_size = empty($_GET["itemsPerPage"]) ? $page_size : (int)$_GET["itemsPerPage"];
        if($page_number<=0 || $page_size<=0) {
            $object = (object) ['error' => $page_number<=0 ? 'Página inválida!' : 'Número de items por página inválido!'];
            $myJSON = json_encode($object);
            echo $myJSON;
            http_response_code(400);
            exit();
        }

        return array($page_number, $page_size);
    }

    // Paginate query results
    function paginate($st, $page_number, $page_size) {
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
    }

?>